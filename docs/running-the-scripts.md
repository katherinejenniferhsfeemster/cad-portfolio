# Running the Scripts

Quick setup for every runnable example in this repo.

## OpenSCAD

Install [OpenSCAD](https://openscad.org/) ≥ 2021.01.

```bash
# Interactive
openscad scripts/openscad/parametric_bracket.scad

# Headless STL export
openscad -o bracket.stl scripts/openscad/parametric_bracket.scad
openscad -o gear.stl    scripts/openscad/involute_spur_gear.scad

# 2D DXF export (top view of a 2D module)
openscad -o bracket_top.dxf -D 'projection=true' scripts/openscad/parametric_bracket.scad
```

Parameters live at the top of each `.scad` file — open the Customizer panel (`Window → Customizer`) or edit in place.

## FreeCAD (Python macros)

Install [FreeCAD](https://www.freecad.org/) ≥ 0.21.

### Inside FreeCAD
1. `Macro → Macros…`
2. `Add…` → pick `scripts/freecad-python/generate_bracket.py`
3. `Execute`

### Headless
```bash
freecadcmd scripts/freecad-python/generate_bracket.py
```
STEP + STL files land in `~/cad-portfolio-exports/`.

## BlenderBIM / Bonsai (IFC audit)

Install [Bonsai](https://bonsaibim.org/) (the successor to BlenderBIM) inside Blender ≥ 4.2, or install IfcOpenShell via pip:

```bash
pip install ifcopenshell
python scripts/blender-bim/ifc_wall_audit.py path/to/building.ifc
# writes path/to/building.wall_audit.md
```

## Optional: reproducible environment

A [`Dockerfile`](../Dockerfile) is provided so the whole pipeline (OpenSCAD + FreeCAD + IfcOpenShell) runs the same way on any machine.

```bash
docker build -t cad-portfolio .
docker run --rm -v $PWD:/work -w /work cad-portfolio \
    openscad -o /work/bracket.stl /work/scripts/openscad/parametric_bracket.scad
```
