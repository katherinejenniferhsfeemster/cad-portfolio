# Parametric Mounting Bracket

A production-oriented L-bracket designed as code. One set of parameters drives the 3D solid, the 2D drawing, and the STEP export.

**Tools:** OpenSCAD, FreeCAD (Python macro), LibreCAD for checking DXF output.

## What this demonstrates

- Parametric part family — seven design parameters produce an entire family of brackets without re-modeling.
- Dual implementation — the same part is defined in `scripts/openscad/parametric_bracket.scad` *and* `scripts/freecad-python/generate_bracket.py`, so the geometry is reproducible in either ecosystem.
- Correct manufacturing details — counterbored holes for M6 cap screws, stiffening rib, inner fillet between flanges.

## Parameters

| Parameter | Default | Notes |
| :-- | --: | :-- |
| length | 80 mm | along X |
| depth | 40 mm | along Y |
| height | 60 mm | vertical leg |
| thickness | 6 mm | material |
| hole_diameter | 6.6 mm | M6 clearance |
| counterbore_diameter | 11 mm | M6 cap head |
| fillet_radius | 8 mm | inner corner |

## Rebuild it

```bash
# OpenSCAD, headless
openscad -o bracket.stl ../../scripts/openscad/parametric_bracket.scad

# FreeCAD, via the Python macro (inside FreeCAD)
# Macro > Execute > scripts/freecad-python/generate_bracket.py
```

## Images

*(drawings and renders live in `../../assets/renders/bracket_*` and `../../assets/drawings/bracket_*` — placeholders until I add the final exports from my latest build)*

- `![Isometric render](../../assets/renders/bracket_iso.png)` *(placeholder)*
- `![Shop drawing](../../assets/drawings/bracket_shop.pdf)` *(placeholder)*
