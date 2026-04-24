<div align="center">

# Katherine Feemster
### Senior CAD Professional · Parametric Design · BIM · CAD-for-AI

[![FreeCAD](https://img.shields.io/badge/FreeCAD-Expert-CB333B?logo=freecad&logoColor=white)](https://www.freecad.org/)
[![AutoCAD](https://img.shields.io/badge/AutoCAD-Expert-E51050?logo=autodesk&logoColor=white)](https://www.autodesk.com/products/autocad)
[![Rhino 3D](https://img.shields.io/badge/Rhino%203D-Advanced-801010?logo=rhinoceros&logoColor=white)](https://www.rhino3d.com/)
[![OpenSCAD](https://img.shields.io/badge/OpenSCAD-Expert-F9D72C?logo=openscad&logoColor=black)](https://openscad.org/)
[![BlenderBIM](https://img.shields.io/badge/BlenderBIM%20%2F%20Bonsai-Advanced-F5792A?logo=blender&logoColor=white)](https://bonsaibim.org/)
[![IFC](https://img.shields.io/badge/IFC%204.3-Fluent-0A6EBD)](https://technical.buildingsmart.org/)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?logo=python&logoColor=white)](https://www.python.org/)

*Ten years designing parts, buildings and reproducible 3D datasets — now helping AI research teams turn CAD into structured training data.*

</div>

---

## About

I'm a senior CAD professional with a decade of hands-on experience spanning mechanical design, architectural BIM, industrial product modeling, and — most recently — building **CAD datasets for AI research**. I care about clean topology, parametric rigor, IFC correctness, and scripts that still build the same part a year from now.

I work fluently across **FreeCAD, AutoCAD, AutoCAD Mechanical, Autodesk Inventor, Rhino 3D, VectorWorks, FreeCAD BIM / IFC, BlenderBIM / Bonsai, OpenSCAD, LibreCAD, QCAD CE, and SolveSpace**, and I script most of my pipelines in Python so they're reproducible and diff-able.

This repository is my living portfolio: project writeups, runnable parametric scripts, exported drawings and renders, and notes on how I approach CAD-for-AI work.

---

## Highlighted Projects

| Project | Tools | What it demonstrates |
| :-- | :-- | :-- |
| **[Parametric Mounting Bracket](projects/parametric-bracket/)** | OpenSCAD, FreeCAD | Code-driven part family with 7 parameters, auto-generated drawings |
| **[BIM Office Module (IFC 4.3)](projects/bim-office-module/)** | FreeCAD BIM, BlenderBIM, IFC | Small office building modeled to IFC 4.3 with MEP and clash notes |
| **[Two-Stage Reduction Gearbox](projects/mechanical-gearbox/)** | Inventor, AutoCAD Mechanical, SolveSpace | Full mechanical assembly, tolerance stack-up, shop drawings |
| **[Freeform Lounge Chair](projects/rhino-freeform-chair/)** | Rhino 3D, Grasshopper | Class-A surfacing, subD-to-NURBS workflow |
| **[CAD → AI Dataset Pipeline](projects/ai-dataset-pipeline/)** | FreeCAD Python, OpenSCAD, Blender | 10k parametric parts exported as STEP + labeled point clouds for ML |

Every project folder contains a short README, the source files (or scripts that regenerate them), and renders/drawings in `assets/`.

---

## Runnable Code Samples

These scripts are real and will build on your machine:

- **[`scripts/openscad/parametric_bracket.scad`](scripts/openscad/parametric_bracket.scad)** — fully parametric L-bracket with fillets, counterbored holes, and a rib. Open in OpenSCAD and tweak the parameters at the top of the file.
- **[`scripts/openscad/involute_spur_gear.scad`](scripts/openscad/involute_spur_gear.scad)** — involute spur gear generator (module, teeth, pressure angle, helix).
- **[`scripts/freecad-python/generate_bracket.py`](scripts/freecad-python/generate_bracket.py)** — FreeCAD macro that builds the same bracket natively and exports STEP + DXF.
- **[`scripts/freecad-python/batch_step_exporter.py`](scripts/freecad-python/batch_step_exporter.py)** — batch-export every body in a FreeCAD document to individual STEP files.
- **[`scripts/blender-bim/ifc_wall_audit.py`](scripts/blender-bim/ifc_wall_audit.py)** — BlenderBIM / IfcOpenShell script that audits IfcWall quantities against design intent.

See [`docs/running-the-scripts.md`](docs/running-the-scripts.md) for setup instructions.

---

## CAD for AI Research

A growing part of my work is preparing CAD data for AI research teams — the same space the role I'm pursuing focuses on. Practical things I've built:

- Parametric generators that emit **STEP / BREP / mesh / point cloud** in a single pass, with JSON labels for every feature (hole, fillet, chamfer, pocket).
- IFC → graph converters that turn buildings into **typed graphs** for GNN training.
- Data-quality checkers: watertightness, manifold edges, duplicate vertices, IFC schema conformance.
- Prompt-to-CAD evaluation harnesses — running generated OpenSCAD / Python against a reference and scoring geometric similarity (Chamfer, Hausdorff, IoU on voxelization).

See [`projects/ai-dataset-pipeline/`](projects/ai-dataset-pipeline/) for the full writeup.

---

## Skills Matrix

**Mechanical & product design** — AutoCAD, AutoCAD Mechanical, Autodesk Inventor, SolveSpace, FreeCAD · GD&T, ASME Y14.5, tolerance stack-ups, shop drawings, sheet metal, weldments.

**Parametric & code-CAD** — OpenSCAD, FreeCAD Python, Grasshopper, CadQuery · parametric part families, DFM rules as code, automated drawing generation.

**3D modeling & surfacing** — Rhino 3D, Blender, Bonsai/BlenderBIM · class-A NURBS, SubD, retopology, UVs.

**BIM & architecture** — FreeCAD BIM, BlenderBIM / Bonsai, VectorWorks, IFC 2x3 / IFC 4 / IFC 4.3 · IfcOpenShell, BCF, clash detection, BIMCollab.

**2D drafting** — LibreCAD, QCAD CE, AutoCAD · ISO / ANSI drafting standards, title block automation.

**Interchange & QA** — STEP (AP214/AP242), IGES, STL, 3MF, DXF, DWG, IFC, glTF · mesh repair, watertightness audits.

**Scripting & tooling** — Python, a bit of Rust and C++ for OCCT, Git, GitHub Actions, Docker, Linux.

---

## Selected Experience

**Senior CAD Engineer — [Company, 2022 – Present]**
Lead CAD-for-AI datasets: 10k+ parametric parts, IFC graph exports, evaluation harnesses for prompt-to-CAD models. Maintain internal FreeCAD / OpenSCAD generators used across three research teams.

**Senior Mechanical Designer — [Company, 2019 – 2022]**
Owned the CAD standard for a 40-person engineering org. Migrated legacy DWG libraries to parametric Inventor templates, cut drawing release time by ~35%.

**BIM Coordinator — [Firm, 2016 – 2019]**
Ran BIM coordination on three mid-rise commercial projects. Introduced BlenderBIM / IfcOpenShell for lightweight IFC QA alongside Revit.

*(Full CV available on request — this repo is the portfolio companion to it.)*

---

## Contact

- GitHub: [@katherinejenniferhsfeemster](https://github.com/katherinejenniferhsfeemster)
- Email: *available on request*
- Location: open to remote / contract engagements

---

<div align="center">
<sub>Built with care in FreeCAD, OpenSCAD, Rhino, and a lot of Python. Every script in this repo runs.</sub>
</div>
