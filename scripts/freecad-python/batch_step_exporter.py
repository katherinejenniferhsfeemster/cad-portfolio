"""
batch_step_exporter.py
----------------------
FreeCAD macro — exports every visible Part/Body in the active
document to its own STEP file, named after the object label.

Usage:
    1. Open your FreeCAD document.
    2. Macro > Macros > select this file > Execute.
    3. STEP files land in ~/cad-portfolio-exports/<doc-name>/.

Author:  Katherine Feemster
License: MIT
"""

from __future__ import annotations
import os
import re
import FreeCAD as App
import Part

EXPORT_ROOT = os.path.expanduser("~/cad-portfolio-exports")

_SAFE = re.compile(r"[^A-Za-z0-9_\-]+")


def _safe_name(s: str) -> str:
    return _SAFE.sub("_", s).strip("_") or "Unnamed"


def export_document(doc=None, root=EXPORT_ROOT):
    doc = doc or App.ActiveDocument
    if doc is None:
        raise RuntimeError("No active FreeCAD document.")

    out_dir = os.path.join(root, _safe_name(doc.Label))
    os.makedirs(out_dir, exist_ok=True)

    exported = 0
    for obj in doc.Objects:
        shape = getattr(obj, "Shape", None)
        if shape is None or shape.isNull():
            continue
        # skip hidden objects
        vis = getattr(obj.ViewObject, "Visibility", True) if obj.ViewObject else True
        if not vis:
            continue

        path = os.path.join(out_dir, f"{_safe_name(obj.Label)}.step")
        try:
            Part.export([obj], path)
            exported += 1
            App.Console.PrintMessage(f"[batch-step] {obj.Label} -> {path}\n")
        except Exception as exc:
            App.Console.PrintError(f"[batch-step] {obj.Label} FAILED: {exc}\n")

    App.Console.PrintMessage(f"[batch-step] done. {exported} file(s) in {out_dir}\n")
    return out_dir


if __name__ == "__main__":
    export_document()
