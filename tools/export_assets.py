"""Cut the source sheets into individual named assets under assets/ui.

Run after analyze_assets.py has been reviewed. The export is idempotent:
assets/ui, assets/audio and assets/branding are rebuilt from scratch each time,
so the source sheets in assets/Tumbling_Tricks_* remain the single source of
truth and are never bundled into the app.
"""

from __future__ import annotations

import shutil
from pathlib import Path

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter

from analyze_assets import SRC_DIRS, analyse
from asset_names import SET_ASSETS, SOUNDS, WHOLE_ASSETS

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets"
UI_DIR = ASSETS / "ui"
AUDIO_DIR = ASSETS / "audio"
BRAND_DIR = ASSETS / "branding"
VERIFY_DIR = ROOT / "tools" / "_analysis" / "verify"
SOUND_SRC = ASSETS / "Tumbling_Tricks_sounds_assets"
ICON_SRC = ASSETS / "Tumbling_Tricks_additional_assets" / "Icon.png"

PADDING = 2
# Largest element side kept in the bundle. Elements are drawn at most at
# full screen width on a 3x device, so 1080 is already generous.
MAX_SIDE = 1080
# WebP keeps the painterly gradients and the alpha channel at a fraction of
# PNG size, which matters for the App Store download budget.
QUALITY_ALPHA = 90
QUALITY_OPAQUE = 86

ADAPTIVE_BACKGROUND = (36, 12, 20)


def find_sheet(stem: str) -> Path:
    for src_dir in SRC_DIRS:
        for suffix in (".webp", ".png"):
            candidate = src_dir / f"{stem}{suffix}"
            if candidate.exists():
                return candidate
    raise FileNotFoundError(stem)


def fit(image: Image.Image, max_side: int = MAX_SIDE) -> Image.Image:
    longest = max(image.size)
    if longest <= max_side:
        return image
    scale = max_side / longest
    return image.resize(
        (round(image.width * scale), round(image.height * scale)), Image.LANCZOS
    )


def save(image: Image.Image, relative: str, max_side: int = MAX_SIDE) -> Path:
    target = UI_DIR / f"{relative}.webp"
    target.parent.mkdir(parents=True, exist_ok=True)
    image = fit(image, max_side)
    transparent = image.getchannel("A").getextrema()[0] < 255
    if transparent:
        image.save(target, "WEBP", quality=QUALITY_ALPHA, method=4, exact=True)
    else:
        image.convert("RGB").save(target, "WEBP", quality=QUALITY_OPAQUE, method=4)
    return target


def tight_crop(image: Image.Image, box: tuple[int, int, int, int]) -> Image.Image:
    """Crop to the box, then shrink to the real alpha bounds plus padding."""
    piece = image.crop(box)
    bounds = piece.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()
    if bounds:
        piece = piece.crop(bounds)
    padded = Image.new("RGBA", (piece.width + 2 * PADDING, piece.height + 2 * PADDING))
    padded.alpha_composite(piece, (PADDING, PADDING))
    return padded


def export_sets() -> list[tuple[str, Path]]:
    exported: list[tuple[str, Path]] = []
    for stem, names in SET_ASSETS.items():
        path = find_sheet(stem)
        report = analyse(path)
        components = report["components"]
        if len(components) != len(names):
            raise SystemExit(
                f"{stem}: detected {len(components)} elements but {len(names)} names "
                "are configured. Re-check tools/_analysis before exporting."
            )
        sheet = Image.open(path).convert("RGBA")
        for comp, name in zip(components, names):
            box = (comp["left"], comp["top"], comp["right"], comp["bottom"])
            exported.append((name, save(tight_crop(sheet, box), name)))
    return exported


def export_wholes() -> list[tuple[str, Path]]:
    exported: list[tuple[str, Path]] = []
    for stem, name in WHOLE_ASSETS.items():
        image = Image.open(find_sheet(stem)).convert("RGBA")
        bounds = image.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox()
        if bounds and bounds != (0, 0, image.width, image.height):
            image = image.crop(bounds)
        # Splash art is displayed edge to edge, so it keeps its native size.
        max_side = 2400 if name.startswith("splash/") else MAX_SIDE
        exported.append((name, save(image, name, max_side)))
    return exported


def export_sounds() -> None:
    AUDIO_DIR.mkdir(parents=True, exist_ok=True)
    for stem, name in SOUNDS.items():
        shutil.copy2(SOUND_SRC / f"{stem}.mp3", AUDIO_DIR / f"{name}.mp3")


def zoom_square(image: Image.Image, size: int, factor: float) -> Image.Image:
    """Scale to a square canvas, cropping the outer edges by `factor`."""
    side = round(min(image.size) / factor)
    left = (image.width - side) // 2
    top = (image.height - side) // 2
    cropped = image.crop((left, top, left + side, top + side))
    return cropped.resize((size, size), Image.LANCZOS)


def export_icons() -> None:
    BRAND_DIR.mkdir(parents=True, exist_ok=True)
    source = Image.open(ICON_SRC).convert("RGB")

    # App Store requires a 1024 icon with no alpha channel. A light zoom removes
    # the dead margin around the arena without clipping the golden ring.
    ios = zoom_square(source, 1024, 1.06)
    ios = ImageEnhance.Contrast(ios).enhance(1.05)
    ios = ios.filter(ImageFilter.UnsharpMask(radius=2, percent=70, threshold=3))
    ios.save(BRAND_DIR / "app_icon_ios.png", "PNG", optimize=True)
    ios.save(BRAND_DIR / "app_icon.png", "PNG", optimize=True)

    # Android adaptive icon: the artwork is full bleed, so it becomes the
    # background layer with enough overscan that the launcher mask only ever
    # crops decoration, never the arena.
    background = zoom_square(source, 1024, 1.34)
    background.save(BRAND_DIR / "app_icon_adaptive_bg.png", "PNG", optimize=True)

    # Foreground carries the arena inside the 66% safe zone.
    safe = round(1024 * 0.66)
    foreground = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    arena = zoom_square(source, safe, 1.18).convert("RGBA")
    mask = Image.new("L", (safe, safe), 0)
    ImageDraw.Draw(mask).ellipse((0, 0, safe - 1, safe - 1), fill=255)
    arena.putalpha(mask)
    offset = (1024 - safe) // 2
    foreground.alpha_composite(arena, (offset, offset))
    foreground.save(BRAND_DIR / "app_icon_adaptive_fg.png", "PNG", optimize=True)

    Image.new("RGB", (1024, 1024), ADAPTIVE_BACKGROUND).save(
        BRAND_DIR / "app_icon_adaptive_solid.png", "PNG", optimize=True
    )


def build_verification_sheets(items: list[tuple[str, Path]]) -> None:
    """Render one labelled contact sheet per category for manual review."""
    VERIFY_DIR.mkdir(parents=True, exist_ok=True)
    groups: dict[str, list[tuple[str, Path]]] = {}
    for name, path in items:
        groups.setdefault(name.split("/")[0], []).append((name, path))

    cell, columns, label_h = 190, 6, 22
    for group, entries in sorted(groups.items()):
        rows = (len(entries) + columns - 1) // columns
        sheet = Image.new(
            "RGB", (columns * cell, rows * (cell + label_h) + 10), (26, 20, 24)
        )
        draw = ImageDraw.Draw(sheet)
        for i, (name, path) in enumerate(entries):
            piece = Image.open(path).convert("RGBA")
            piece.thumbnail((cell - 16, cell - 16), Image.LANCZOS)
            x = (i % columns) * cell + (cell - piece.width) // 2
            y = (i // columns) * (cell + label_h) + (cell - piece.height) // 2
            sheet.paste(piece, (x, y), piece)
            draw.text(
                ((i % columns) * cell + 6, (i // columns) * (cell + label_h) + cell),
                name.split("/", 1)[1],
                fill=(240, 205, 130),
            )
        sheet.save(VERIFY_DIR / f"{group}.png")


def main() -> None:
    for directory in (UI_DIR, AUDIO_DIR, BRAND_DIR, VERIFY_DIR):
        shutil.rmtree(directory, ignore_errors=True)

    exported = export_sets() + export_wholes()
    export_sounds()
    export_icons()
    build_verification_sheets(exported)

    total = sum(p.stat().st_size for p in UI_DIR.rglob("*.webp"))
    print(f"exported {len(exported)} images into assets/ui ({total / 1024:.0f} KB)")
    print(f"exported {len(SOUNDS)} sounds into assets/audio")
    print("icons written to assets/branding")


if __name__ == "__main__":
    main()
