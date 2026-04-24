# Two-Stage Reduction Gearbox

A fully detailed two-stage spur-gear reduction gearbox, designed in **Autodesk Inventor** with a parallel sketch-based model in **SolveSpace**, 2D shop drawings in **AutoCAD Mechanical**.

**Tools:** Autodesk Inventor, AutoCAD Mechanical, SolveSpace, OpenSCAD (for gear profile generation and sanity-checks).

## Specs

| Parameter | Value |
| :-- | :-- |
| Input speed | 1,450 rpm |
| Total reduction ratio | 9.6 : 1 |
| Input torque | 14 N·m |
| Output torque | ~126 N·m |
| Stages | 2 (3.2 : 1 and 3.0 : 1) |
| Module | m = 2 |
| Pressure angle | 20° |
| Housing | Aluminum, CNC-machined |

## What this demonstrates

- Complete mechanical workflow from kinematic sizing → gear geometry → shaft and bearing selection → housing → shop drawings → tolerance stack-up.
- **GD&T to ASME Y14.5** on all mating features — bearing bores, shaft diameters, bolt patterns.
- **Tolerance stack-up analysis** (RSS + worst-case) on the shaft-bearing-housing chain; documented in `tolerance_stack.xlsx` *(placeholder)*.
- **Cross-tool verification** — gear geometry generated with `scripts/openscad/involute_spur_gear.scad` and compared to the Inventor model (Hausdorff distance < 0.02 mm on a 24-tooth m=2 gear).
- Release-ready 2D drawings with title block, revision history, BOM, and ballooned assembly.

## Files

- `gearbox_assembly.iam` — Inventor assembly *(placeholder)*
- `gearbox.step` — STEP AP214 export *(placeholder)*
- `drawings/*.pdf` — shop drawings *(placeholder)*
- `tolerance_stack.xlsx` — stack-up analysis *(placeholder)*
