#!/usr/bin/env python3
"""Generate lib/design/app_assets.dart from the curated files in assets/.

Run from the project root after adding or renaming any curated asset:

    python3 tools/gen_asset_catalog.py

Only the directories listed in BUNDLED_DIRS are scanned; the raw source sheets
are never referenced from Dart code.
"""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "lib" / "design" / "app_assets.dart"

# Directory -> Dart class name. Order controls the order in the generated file.
BUNDLED_DIRS: dict[str, str] = {
    "assets/ui/backdrop": "Backdrops",
    "assets/ui/brand": "Brand",
    "assets/ui/splash": "SplashArt",
    "assets/ui/trick": "TrickArt",
    "assets/ui/status": "StatusArt",
    "assets/ui/checklist": "ChecklistArt",
    "assets/ui/equipment": "EquipmentArt",
    "assets/ui/emblem": "Emblems",
    "assets/ui/ornament": "Ornaments",
    "assets/ui/decor": "Decor",
    "assets/ui/cue_frame": "CueFrames",
    "assets/ui/paper": "Papers",
    "assets/ui/page": "Pages",
    "assets/ui/progress": "ProgressArt",
    "assets/ui/timeline": "TimelineArt",
    "assets/ui/object": "Objects",
    "assets/audio": "Sfx",
    "assets/legal/fonts": "FontLicences",
}

RESERVED = {
    "class", "const", "default", "enum", "extends", "false", "final", "for",
    "if", "in", "is", "new", "null", "return", "super", "switch", "this",
    "true", "var", "void", "while", "with", "assert", "break", "case", "catch",
    "continue", "do", "else", "rethrow", "throw", "try",
}


def camel(stem: str) -> str:
    parts = re.split(r"[^0-9a-zA-Z]+", stem)
    parts = [p for p in parts if p]
    head = parts[0].lower()
    name = head + "".join(p[:1].upper() + p[1:] for p in parts[1:])
    if name in RESERVED or name[0].isdigit():
        name = f"a{name[:1].upper()}{name[1:]}"
    return name


def main() -> int:
    lines: list[str] = [
        "// GENERATED FILE - do not edit by hand.",
        "// Regenerate with: python3 tools/gen_asset_catalog.py",
        "",
        "/// Every bundled asset path, grouped by role.",
        "///",
        "/// Using these constants instead of raw strings keeps `precacheImage`",
        "/// during bootstrap and the widget tree in sync: a renamed file breaks",
        "/// the build instead of showing an empty box at runtime.",
        "library;",
        "",
    ]

    all_images: list[str] = []
    total = 0

    for rel, cls in BUNDLED_DIRS.items():
        directory = ROOT / rel
        if not directory.is_dir():
            raise SystemExit(f"missing directory: {rel}")
        files = sorted(p for p in directory.iterdir() if p.is_file() and not p.name.startswith("."))
        if not files:
            raise SystemExit(f"no files in: {rel}")

        lines.append(f"abstract final class {cls} {{")
        members: list[str] = []
        for f in files:
            member = camel(f.stem)
            members.append(member)
            lines.append(f"  static const String {member} = '{rel}/{f.name}';")
            total += 1
            if f.suffix.lower() in {".webp", ".png", ".jpg", ".jpeg"}:
                all_images.append(f"{cls}.{member}")
        lines.append("")
        lines.append("  static const List<String> values = <String>[")
        for member in members:
            lines.append(f"    {member},")
        lines.append("  ];")
        lines.append("}")
        lines.append("")

    lines.append("/// Every bundled image, used by the bootstrap warm-up step.")
    lines.append("const List<String> kAllImageAssets = <String>[")
    for entry in all_images:
        lines.append(f"  {entry},")
    lines.append("];")
    lines.append("")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {OUT.relative_to(ROOT)}: {total} assets, {len(all_images)} images")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
