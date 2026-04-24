// ============================================================
// Parametric L-Bracket
// Author: Katherine Feemster
// License: MIT
//
// A production-style parametric mounting bracket:
//   - horizontal base flange with a grid of counterbored holes
//   - vertical leg with through-holes
//   - inner fillet between the two flanges
//   - optional triangular stiffening rib
//
// Every dimension below is a design parameter — change it and
// the solid (plus derived STL / DXF) updates.
//
// F5 preview, F6 for final render, then File > Export > STL / DXF
// ============================================================

/* [Overall dimensions] */
length        = 80;   // mm, along X (width of both flanges)
height        = 60;   // mm, along Z (vertical leg height)
depth         = 40;   // mm, along Y (base flange depth)
thickness     = 6;    // mm, material thickness

/* [Holes] */
hole_diameter        = 6.6;  // M6 clearance
counterbore_diameter = 11;   // M6 cap head
counterbore_depth    = 4;
hole_inset           = 10;   // distance from edges
hole_count_base      = 4;    // holes in base flange (2x2 grid)
hole_count_vertical  = 2;    // holes in vertical leg

/* [Features] */
fillet_radius = 8;    // inner fillet between flanges
rib_enabled   = true; // triangular stiffening rib
rib_thickness = 4;

/* [Quality] */
$fn = 64;

// ------------------------------------------------------------
module counterbored_hole(d_through, d_cbore, cbore_depth, total_h) {
    union() {
        cylinder(h = total_h + 0.2, d = d_through);
        translate([0, 0, total_h - cbore_depth])
            cylinder(h = cbore_depth + 0.2, d = d_cbore);
    }
}

// A fillet that bridges the inside corner between the base (on XY)
// and the vertical leg (on XZ, at y=thickness). Built as a quarter-
// cylinder inscribed in a (t+r) x (t+r) cross section.
module inner_fillet() {
    r = fillet_radius;
    // Solid that fills the corner, minus a quarter-cylinder.
    translate([0, 0, 0]) {
        difference() {
            translate([0, thickness, thickness])
                cube([length, r, r]);
            translate([-0.5, thickness + r, thickness + r])
                rotate([0, 90, 0])
                    cylinder(h = length + 1, r = r);
        }
    }
}

// Triangular rib in the XZ plane, centered on the bracket's X.
// Right-angle at the inside corner, hypotenuse running diagonally.
module rib() {
    rib_h = height - thickness - 4;    // along Z
    rib_l = depth  - thickness - 4;    // along Y
    // extrude a triangle in Y-Z plane along the X axis
    translate([length/2 - rib_thickness/2, thickness, thickness])
        rotate([90, 0, 90])            // YZ polygon → extrude along X
            linear_extrude(height = rib_thickness)
                polygon([[0, 0], [rib_l, 0], [0, rib_h]]);
}

module base_flange() {
    difference() {
        cube([length, depth, thickness]);

        // 2 × 2 grid of counterbored holes
        rows = 2;
        cols = hole_count_base / rows;
        x_step = (length - 2*hole_inset) / max(cols - 1, 1);
        y_step = (depth  - 2*hole_inset) / max(rows - 1, 1);
        for (i = [0 : cols - 1])
            for (j = [0 : rows - 1])
                translate([hole_inset + i*x_step,
                           hole_inset + j*y_step,
                           -0.1])
                    counterbored_hole(hole_diameter,
                                      counterbore_diameter,
                                      counterbore_depth,
                                      thickness);
    }
}

module vertical_leg() {
    difference() {
        // The leg sits on the back edge of the base (y = 0 .. thickness)
        cube([length, thickness, height]);

        // Through-holes spaced along the leg
        x_step = (length - 2*hole_inset) / max(hole_count_vertical - 1, 1);
        for (i = [0 : hole_count_vertical - 1])
            translate([hole_inset + i*x_step,
                       -0.1,
                       height - hole_inset])
                rotate([-90, 0, 0])
                    cylinder(h = thickness + 0.2, d = hole_diameter);
    }
}

module bracket() {
    union() {
        base_flange();
        vertical_leg();
        inner_fillet();
        if (rib_enabled) rib();
    }
}

bracket();

// ------------------------------------------------------------
echo("=== Parametric Bracket ===");
echo(length=length, depth=depth, height=height, thickness=thickness);
echo(base_holes=hole_count_base, leg_holes=hole_count_vertical);
echo(approx_volume_cm3 = (length*depth*thickness + length*thickness*height)/1000);
