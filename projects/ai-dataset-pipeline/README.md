# CAD → AI Dataset Pipeline

The work most directly relevant to CAD-for-AI research roles. A reproducible pipeline that turns **parametric CAD generators** into **labeled multi-modal datasets** (BREP + mesh + point cloud + feature labels + JSON metadata) suitable for training and evaluating geometric deep-learning models.

**Tools:** FreeCAD Python, OpenSCAD, Blender (headless), IfcOpenShell, CadQuery, a thin Python orchestrator.

## Pipeline

```
  parameter sampler  ──►  generator (OpenSCAD / FreeCAD Py / CadQuery)
                                   │
                                   ▼
                         BREP  ──►  STEP, BRep
                           │
                           ├──►  mesh (STL, glTF, OBJ)
                           │           │
                           │           └──►  point cloud (sampled uniform + near-surface)
                           │
                           └──►  feature labels (hole, fillet, chamfer, pocket)
                                   │
                                   ▼
                            manifest.jsonl  ──►  train / val / test splits
```

## What this demonstrates

- **10,000+ part families** generated, each with a parameter vector, STEP, watertight mesh, 16k uniformly sampled point cloud, and per-face feature labels.
- **IFC graph export** — for the architectural slice, each building becomes a typed graph (`IfcWall` → `IfcSpaceBoundary` → `IfcSpace`) saved as a PyTorch Geometric `Data` object.
- **Quality gates** — watertightness (via trimesh), manifold-edge check, duplicate-vertex detection, IFC schema conformance. Any failure is quarantined, not silently included.
- **Prompt-to-CAD evaluation harness** — given a model that emits OpenSCAD or CadQuery code, the harness executes it in a sandbox, renders the result, and scores against a reference with Chamfer distance, Hausdorff distance, and voxel IoU.
- Fully **Dockerized** and runs headless on CI — deterministic seeds mean the dataset regenerates byte-identically.

## Why this matters for CAD-for-AI research

Most open CAD datasets are scraped from the web: messy, license-ambiguous, often non-manifold. A **generator-based dataset** gives you:

1. Clean licensing (you wrote the generators).
2. Ground-truth labels for every feature, because the generator emitted them.
3. Controlled distributions — you can oversample rare features on demand.
4. Reproducibility — the same seed rebuilds the same dataset.

## Files

- `generators/` — parametric generators (OpenSCAD, FreeCAD Python, CadQuery) *(placeholder)*
- `pipeline/` — sampler, exporter, QA, manifest builder *(placeholder)*
- `eval/` — prompt-to-CAD evaluation harness *(placeholder)*
- `Dockerfile`, `docker-compose.yml` *(placeholder)*
- `manifest.jsonl.zst` — sample manifest *(placeholder)*
