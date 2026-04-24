"""
generate_bracket.py
-------------------
FreeCAD macro — builds the same parametric L-bracket as
`scripts/openscad/parametric_bracket.scad`, but natively in FreeCAD
so the result is a proper solid with history, ready for STEP / DXF
export.

Run inside FreeCAD:
    Macro > Macros > add this file > Execute
Or from the FreeCAD Python console:
    exec(open('/path/to/generate_bracket.py').read())

Author:  Katherine Feemster
License: MIT
"""

from __future__ import annotations
import os
import FreeCAD as App
import Part
import Draft  # noqa: F401 — used for drawing export when available

# ---------- Parameters ---------------------------------------------------
PARAMS = {
    "length":        80.0,
    "height":        60.0,
    "depth":         40.0,
    "thickness":     6.0,
    "hole_d":        6.6,
    "cbore_d":       11.0,
    "cbore_depth":   4.0,
    "hole_inset":    10.0,
    "holes_base":    4,    # 2x2 grid
    "holes_leg":     2,
    "fillet_r":      8.0,
    "rib":           True,
    "rib_thickness": 4.0,
}

EXPORT_DIR = os.path.expanduser("~/cad-portfolio-exports")

# ---------- Helpers ------------------------------------------------------
def _counterbored_hole(cx, cy, cz, p, axis=App.Vector(0, 0, -1)):
    """Return a compound representing a through-hole with counterbore."""
    through = Part.makeCylinder(p["hole_d"] / 2,
                                p["thickness"] + 2,
                                App.Vector(cx, cy, cz + 1),
                                axis)
    cbore   = Part.makeCylinder(p["cbore_d"] / 2,
                                p["cbore_depth"] + 0.1,
                                App.Vector(cx, cy, cz + 0.05),
                                axis)
    return through.fuse(cbore)


def build_bracket(p=PARAMS):
    # --- base flange ---
    base = Part.makeBox(p["length"], p["depth"], p["thickness"])

    # 2x2 grid of holes in the base
    cols = p["holes_base"] // 2
    rows = 2
    x_step = (p["length"] - 2 * p["hole_inset"]) / max(cols - 1, 1)
    y_step = (p["depth"]  - 2 * p["hole_inset"]) / max(rows - 1, 1)

    for i in range(cols):
        for j in range(rows):
            x = p["hole_inset"] + i * x_step
            y = p["hole_inset"] + j * y_step
            hole = _counterbored_hole(x, y, p["thickness"], p)
            base = base.cut(hole)

    # --- vertical leg ---
    leg = Part.makeBox(p["length"], p["thickness"], p["height"])
    x_step = (p["length"] - 2 * p["hole_inset"]) / max(p["holes_leg"] - 1, 1)
    for i in range(p["holes_leg"]):
        x = p["hole_inset"] + i * x_step
        z = p["height"] - p["hole_inset"]
        cyl = Part.makeCylinder(p["hole_d"] / 2,
                                p["thickness"] + 2,
                                App.Vector(x, -1, z),
                                App.Vector(0, 1, 0))
        leg = leg.cut(cyl)

    bracket = base.fuse(leg)

    # --- rib ---
    if p["rib"]:
        rib_h = p["height"] - p["thickness"] - 4
        rib_l = p["depth"]  - p["thickness"] - 4
        pts = [
            App.Vector(0,      0,          0),
            App.Vector(0,      rib_l,      0),
            App.Vector(0,      0,          rib_h),
            App.Vector(0,      0,          0),
        ]
        wire = Part.makePolygon(pts)
        face = Part.Face(wire)
        rib  = face.extrude(App.Vector(p["rib_thickness"], 0, 0))
        rib.translate(App.Vector(
            p["length"] / 2 - p["rib_thickness"] / 2,
            p["thickness"],
            p["thickness"],
        ))
        bracket = bracket.fuse(rib)

    # --- inner fillet between flanges ---
    try:
        edges = []
        for e in bracket.Edges:
            v1, v2 = e.Vertexes[0].Point, e.Vertexes[-1].Point
            # edge along X at (y≈thickness, z≈thickness)
            if (abs(v1.y - p["thickness"]) < 1e-3
                    and abs(v1.z - p["thickness"]) < 1e-3
                    and abs(v2.y - p["thickness"]) < 1e-3
                    and abs(v2.z - p["thickness"]) < 1e-3):
                edges.append(e)
        if edges:
            bracket = bracket.makeFillet(p["fillet_r"], edges)
    except Exception as exc:
        App.Console.PrintWarning(f"[bracket] fillet skipped: {exc}\n")

    return bracket


def main():
    doc = App.newDocument("Bracket")
    shape = build_bracket()
    Part.show(shape, "Bracket")
    doc.recompute()

    os.makedirs(EXPORT_DIR, exist_ok=True)
    step_path = os.path.join(EXPORT_DIR, "bracket.step")
    stl_path  = os.path.join(EXPORT_DIR, "bracket.stl")
    shape.exportStep(step_path)
    shape.exportStl(stl_path)
    App.Console.PrintMessage(f"[bracket] exported:\n  {step_path}\n  {stl_path}\n")


if __name__ == "__main__":
    main()
