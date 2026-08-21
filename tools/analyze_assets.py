"""Detect individual elements inside the source asset sheets.

Each sheet is an RGBA image where elements sit on a transparent background.
The script reports, for every sheet, whether it is a single whole illustration
or a set, and where each element of a set lives. Output is a JSON report plus
annotated contact sheets used for manual verification before slicing.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, asdict
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage

ROOT = Path(__file__).resolve().parent.parent
SRC_DIRS = [
    ROOT / "assets" / "Tumbling_Tricks_gameplay_assets",
    ROOT / "assets" / "Tumbling_Tricks_additional_assets",
]
OUT_DIR = ROOT / "tools" / "_analysis"

# Sheets we must never touch, per the project rules.
EXCLUDED = {
    "stage_permit_landscape",
    "stage_permit_portrait",
    "stage_offline_landscape",
    "stage_offline_portrait",
}

ALPHA_THRESHOLD = 16
OPAQUE_WHOLE_RATIO = 0.97
CLOSING_RADIUS = 6
# Negative disables bounding-box merging: neighbouring elements on these sheets
# sit so close that their boxes overlap even when the artwork does not.
MERGE_GAP = -1
MIN_AREA_RATIO = 0.0004
MIN_SIDE = 24

# Per-sheet corrections applied after automatic detection, verified visually
# against the annotated contact sheets in tools/_analysis.
#   force_whole  - treat the sheet as a single illustration
#   refine       - element indices to re-detect with no gap closing, because
#                  neighbouring artwork touches and got captured as one box
#   merge_groups - element indices that belong to one object but are detached
#                  in the artwork (sparkles, swirls, loose sub-parts)
SHEET_TUNING: dict[str, dict] = {
    "Game_Name": {"force_whole": True},
    "Performance_Timeline_Elements_Set_asset": {"refine": [1, 10, 22, 23]},
    "trick_category_icons_set_asset": {"merge_groups": [[3, 4]]},
}


@dataclass
class Component:
    index: int
    left: int
    top: int
    right: int
    bottom: int

    @property
    def width(self) -> int:
        return self.right - self.left

    @property
    def height(self) -> int:
        return self.bottom - self.top


def disk(radius: int) -> np.ndarray:
    span = np.arange(-radius, radius + 1)
    yy, xx = np.meshgrid(span, span, indexing="ij")
    return (yy**2 + xx**2) <= radius**2


def boxes_touch(a: Component, b: Component, gap: int) -> bool:
    return (
        a.left - gap <= b.right
        and b.left - gap <= a.right
        and a.top - gap <= b.bottom
        and b.top - gap <= a.bottom
    )


def merge_boxes(boxes: list[Component], gap: int) -> list[Component]:
    """Greedily union boxes that sit within `gap` pixels of each other."""
    if gap < 0:
        return list(boxes)
    merged = list(boxes)
    changed = True
    while changed:
        changed = False
        for i in range(len(merged)):
            for j in range(i + 1, len(merged)):
                if boxes_touch(merged[i], merged[j], gap):
                    a, b = merged[i], merged[j]
                    union = Component(
                        index=0,
                        left=min(a.left, b.left),
                        top=min(a.top, b.top),
                        right=max(a.right, b.right),
                        bottom=max(a.bottom, b.bottom),
                    )
                    merged = [
                        c for k, c in enumerate(merged) if k not in (i, j)
                    ] + [union]
                    changed = True
                    break
            if changed:
                break
    return merged


def reading_order(boxes: list[Component]) -> list[Component]:
    """Sort into rows top-to-bottom, then left-to-right inside each row."""
    remaining = sorted(boxes, key=lambda c: (c.top, c.left))
    rows: list[list[Component]] = []
    for box in remaining:
        placed = False
        for row in rows:
            ref = row[0]
            overlap = min(box.bottom, ref.bottom) - max(box.top, ref.top)
            if overlap > 0.4 * min(box.height, ref.height):
                row.append(box)
                placed = True
                break
        if not placed:
            rows.append([box])
    ordered: list[Component] = []
    for row in rows:
        ordered.extend(sorted(row, key=lambda c: c.left))
    for i, box in enumerate(ordered, start=1):
        box.index = i
    return ordered


def detect(mask: np.ndarray, radius: int, min_area: float) -> list[Component]:
    source = ndimage.binary_closing(mask, structure=disk(radius)) if radius else mask
    labels, _ = ndimage.label(source)
    boxes: list[Component] = []
    for slice_y, slice_x in ndimage.find_objects(labels):
        region = labels[slice_y, slice_x]
        if int((region > 0).sum()) < min_area:
            continue
        if max(slice_x.stop - slice_x.start, slice_y.stop - slice_y.start) < MIN_SIDE:
            continue
        boxes.append(
            Component(0, slice_x.start, slice_y.start, slice_x.stop, slice_y.stop)
        )
    return boxes


def refine_box(mask: np.ndarray, box: Component) -> list[Component]:
    """Re-detect inside a box without gap closing to separate touching artwork."""
    sub = mask[box.top : box.bottom, box.left : box.right]
    min_area = 0.01 * sub.size
    found = detect(sub, radius=0, min_area=min_area)
    if len(found) < 2:
        return [box]
    return [
        Component(
            0,
            box.left + c.left,
            box.top + c.top,
            box.left + c.right,
            box.top + c.bottom,
        )
        for c in found
    ]


def union(boxes: list[Component]) -> Component:
    return Component(
        0,
        min(b.left for b in boxes),
        min(b.top for b in boxes),
        max(b.right for b in boxes),
        max(b.bottom for b in boxes),
    )


def analyse(path: Path) -> dict:
    image = Image.open(path).convert("RGBA")
    alpha = np.array(image.getchannel("A"))
    total = alpha.size
    opaque_ratio = float((alpha > 240).sum() / total)

    result: dict = {
        "name": path.stem,
        "file": str(path.relative_to(ROOT)),
        "width": image.width,
        "height": image.height,
        "opaque_ratio": round(opaque_ratio, 4),
    }

    tuning = SHEET_TUNING.get(path.stem, {})
    if opaque_ratio >= OPAQUE_WHOLE_RATIO or tuning.get("force_whole"):
        result["kind"] = "whole"
        result["components"] = []
        return result

    mask = alpha > ALPHA_THRESHOLD
    boxes = detect(
        mask,
        radius=tuning.get("closing_radius", CLOSING_RADIUS),
        min_area=MIN_AREA_RATIO * total,
    )
    boxes = reading_order(merge_boxes(boxes, tuning.get("merge_gap", MERGE_GAP)))

    for group in tuning.get("merge_groups", []):
        members = [b for b in boxes if b.index in group]
        if len(members) > 1:
            boxes = [b for b in boxes if b.index not in group] + [union(members)]

    refine = set(tuning.get("refine", []))
    if refine:
        expanded: list[Component] = []
        for box in boxes:
            expanded.extend(refine_box(mask, box) if box.index in refine else [box])
        boxes = expanded

    boxes = reading_order(boxes)
    result["kind"] = "whole" if len(boxes) <= 1 else "set"
    result["components"] = [asdict(b) for b in boxes]
    return result


def annotate(path: Path, report: dict) -> None:
    image = Image.open(path).convert("RGBA")
    canvas = Image.new("RGBA", image.size, (24, 18, 22, 255))
    canvas.alpha_composite(image)
    draw = ImageDraw.Draw(canvas)
    for comp in report["components"]:
        draw.rectangle(
            [comp["left"], comp["top"], comp["right"], comp["bottom"]],
            outline=(0, 255, 170, 255),
            width=4,
        )
        label = str(comp["index"])
        draw.rectangle(
            [comp["left"], comp["top"], comp["left"] + 46, comp["top"] + 46],
            fill=(0, 255, 170, 255),
        )
        draw.text((comp["left"] + 14, comp["top"] + 14), label, fill=(0, 0, 0, 255))
    scale = 620 / canvas.width
    preview = canvas.resize(
        (int(canvas.width * scale), int(canvas.height * scale)), Image.LANCZOS
    )
    preview.convert("RGB").save(OUT_DIR / f"{report['name']}__boxes.png")


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    reports = []
    for src_dir in SRC_DIRS:
        for path in sorted(src_dir.glob("*")):
            if path.suffix.lower() not in {".webp", ".png"}:
                continue
            if path.stem in EXCLUDED:
                continue
            report = analyse(path)
            annotate(path, report)
            reports.append(report)
            print(
                f"{report['kind']:>5}  {report['name']:<46}"
                f" opaque={report['opaque_ratio']:.2f}"
                f" elements={len(report['components'])}"
            )
    (OUT_DIR / "report.json").write_text(json.dumps(reports, indent=2))


if __name__ == "__main__":
    main()
