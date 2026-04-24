# BIM Office Module — IFC 4.3

A small two-storey office module modeled end-to-end in **FreeCAD BIM** and refined in **BlenderBIM / Bonsai**, exported as a schema-valid **IFC 4.3** file.

**Tools:** FreeCAD BIM, BlenderBIM / Bonsai, IfcOpenShell, BCF for issue tracking.

## Scope

- ~420 m² two-storey office module, steel frame, CLT floors, curtain wall on south façade.
- Full IFC 4.3 export: site, building, storeys, spaces, walls, slabs, columns, beams, windows, doors, railings, and a light MEP run (HVAC + cable trays).
- Pset_WallCommon, Pset_SpaceCommon, and QtoSets populated on every relevant element.

## What this demonstrates

- **Schema discipline** — every element has a `PredefinedType`, `Pset_*Common`, and `Qto_*BaseQuantities`. No "NOTDEFINED" left behind.
- **Material Layer Sets** on walls and slabs, with correct layer order and thickness.
- **Spaces with boundaries** (IfcRelSpaceBoundary 2nd level) for downstream energy analysis.
- **BCF round-trip** — coordination issues raised in BlenderBIM, exported as BCF 3.0, tracked to resolution.
- **Automated QA** — the audit script at `scripts/blender-bim/ifc_wall_audit.py` runs on this model in CI.

## Files

- `office_module.ifc` — IFC 4.3 export *(placeholder — add your export here)*
- `office_module.FCStd` — FreeCAD source *(placeholder)*
- `office_module.blend` — BlenderBIM / Bonsai source *(placeholder)*
- `issues.bcf` — coordination issues *(placeholder)*

## QA report sample

```
# IfcWall audit — office_module.ifc
Walls audited: 38
Total issues: 0
```

*(regenerated with `python scripts/blender-bim/ifc_wall_audit.py office_module.ifc`)*
