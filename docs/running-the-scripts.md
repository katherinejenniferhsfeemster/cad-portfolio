# Running the Scripts

Quick setup for every runnable example in this repo.

## OpenSCAD

Install [OpenSCAD](https://openscad.org/) ≥ 2021.01.

```bash
openscad scripts/openscad/parametric_bracket.scad
openscad -o bracket.stl scripts/openscad/parametric_bracket.scad
openscad -o gear.stl    scripts/openscad/involute_spur_gear.scad
```

## FreeCAD (Python macros)

```bash
freecadcmd scripts/freecad-python/generate_bracket.py
```

## BlenderBIM / Bonsai (IFC audit)

```bash
pip install ifcopenshell
python scripts/blender-bim/ifc_wall_audit.py path/to/building.ifc
```
