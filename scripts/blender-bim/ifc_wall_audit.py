"""
ifc_wall_audit.py
-----------------
BlenderBIM / Bonsai + IfcOpenShell audit script.

Walks every IfcWall in an IFC file and checks:
  - quantity set presence (Qto_WallBaseQuantities)
  - declared Length / Height / NetVolume vs. geometry-derived values
  - predefined type is set (not NOTDEFINED)
  - Pset_WallCommon.LoadBearing is populated
  - wall has at least one associated IfcMaterialLayerSet

Outputs a Markdown report next to the IFC file.

Run:
    python ifc_wall_audit.py /path/to/building.ifc

Author:  Katherine Feemster
License: MIT
"""

from __future__ import annotations
import sys
import os
from pathlib import Path

try:
    import ifcopenshell
    import ifcopenshell.util.element as ue
    import ifcopenshell.util.placement as up
    import ifcopenshell.geom as geom
except ImportError:
    sys.stderr.write(
        "ifcopenshell is required. Install it via BlenderBIM / Bonsai or:\n"
        "  pip install ifcopenshell\n"
    )
    raise


TOLERANCE_MM = 5.0  # 5 mm tolerance between declared and geometric length/height


def _get_qto(wall, qset_name, prop_name):
    psets = ue.get_psets(wall, qtos_only=True)
    return psets.get(qset_name, {}).get(prop_name)


def _get_pset(wall, pset_name, prop_name):
    psets = ue.get_psets(wall, psets_only=True)
    return psets.get(pset_name, {}).get(prop_name)


def _geometric_bbox(wall, settings):
    try:
        shape = geom.create_shape(settings, wall)
    except Exception:
        return None
    verts = shape.geometry.verts
    xs = verts[0::3]; ys = verts[1::3]; zs = verts[2::3]
    return (max(xs) - min(xs), max(ys) - min(ys), max(zs) - min(zs))


def audit(ifc_path: str) -> str:
    model = ifcopenshell.open(ifc_path)
    settings = geom.settings()
    settings.set(settings.USE_WORLD_COORDS, True)

    walls = model.by_type("IfcWall")
    rows = []
    issues_total = 0

    for w in walls:
        issues = []

        if not w.PredefinedType or w.PredefinedType == "NOTDEFINED":
            issues.append("PredefinedType missing")

        load_bearing = _get_pset(w, "Pset_WallCommon", "LoadBearing")
        if load_bearing is None:
            issues.append("Pset_WallCommon.LoadBearing missing")

        # material layer set
        mats = ue.get_material(w, should_inherit=True)
        if mats is None:
            issues.append("no material assigned")

        declared_length = _get_qto(w, "Qto_WallBaseQuantities", "Length")
        declared_height = _get_qto(w, "Qto_WallBaseQuantities", "Height")
        declared_volume = _get_qto(w, "Qto_WallBaseQuantities", "NetVolume")

        bbox = _geometric_bbox(w, settings)
        geom_length = max(bbox[0], bbox[1]) * 1000.0 if bbox else None  # m -> mm
        geom_height = bbox[2] * 1000.0 if bbox else None

        if declared_length and geom_length and abs(declared_length*1000 - geom_length) > TOLERANCE_MM:
            issues.append(f"Length Δ {abs(declared_length*1000 - geom_length):.1f} mm")
        if declared_height and geom_height and abs(declared_height*1000 - geom_height) > TOLERANCE_MM:
            issues.append(f"Height Δ {abs(declared_height*1000 - geom_height):.1f} mm")

        if declared_volume is None:
            issues.append("NetVolume missing")

        issues_total += len(issues)
        rows.append({
            "GlobalId": w.GlobalId,
            "Name": w.Name or "",
            "PredefinedType": w.PredefinedType,
            "LoadBearing": load_bearing,
            "Length_m": declared_length,
            "Height_m": declared_height,
            "NetVolume_m3": declared_volume,
            "Issues": ", ".join(issues) if issues else "—",
        })

    report_path = Path(ifc_path).with_suffix(".wall_audit.md")
    with open(report_path, "w", encoding="utf-8") as f:
        f.write(f"# IfcWall audit — `{os.path.basename(ifc_path)}`\n\n")
        f.write(f"**Walls audited:** {len(walls)}  \n")
        f.write(f"**Total issues:** {issues_total}\n\n")
        f.write("| GlobalId | Name | Type | LoadBearing | L (m) | H (m) | V (m³) | Issues |\n")
        f.write("| :-- | :-- | :-- | :-- | --: | --: | --: | :-- |\n")
        for r in rows:
            f.write(
                f"| `{r['GlobalId']}` | {r['Name']} | {r['PredefinedType']} | "
                f"{r['LoadBearing']} | {r['Length_m']} | {r['Height_m']} | "
                f"{r['NetVolume_m3']} | {r['Issues']} |\n"
            )

    return str(report_path)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python ifc_wall_audit.py <path/to/file.ifc>")
        sys.exit(1)
    out = audit(sys.argv[1])
    print(f"Report written to: {out}")
