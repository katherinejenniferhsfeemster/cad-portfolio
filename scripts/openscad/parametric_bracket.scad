// ============================================================
// Parametric L-Bracket
// Author: Katherine Feemster
// License: MIT
//
// A production-style parametric mounting bracket.
// Every dimension below is a design parameter — change the
// values and the bracket (including drawings) updates.
//
// Render:  F5 preview, F6 for final render, then File > Export > STL / DXF
// ============================================================

/* [Overall dimensions] */
length        = 80;   // mm, along X
height        = 60;   // mm, along Z (vertical leg)
depth         = 40;   // mm, along Y
thickness     = 6;    // mm, material thickness

/* [Holes] */
hole_diameter        = 6.6;  // M6 clearance
counterbore_diameter = 11;   // M6 cap head
counterbore_depth    = 4;
hole_inset           = 10;   // distance from edges
hole_count_base      = 4;    // holes in base flange
hole_count_vertical  = 2;    // holes in vertical leg

/* [Features] */
fillet_radius = 8;    // inner fillet between flanges
rib_enabled   = true; // triangular stiffening rib
rib_thickness = 4;

/* [Quality] */
$fn = 64;

// ------------------------------------------------------------
module rounded_inner_corner(r, t, l) {
    // Creates the inner fillet between the two flanges
    difference() {
        cube([t + r, l, t + r]);
        translate([t + r, -0.5, t + r])
            rotate([-90, 0, 0])
                cylinder(h = l + 1, r = r);
    }
}

module rib() {
    // Triangular stiffener on the back face
    rib_h = height - thickness - 4;
    rib_l = depth  - thickness - 4;
    translate([length/2 - rib_thickness/2, thickness, thickness])
        linear_extrude(height = rib_thickness)
            polygon([[0,0], [rib_l, 0], [0, rib_h]]);
}

module counterbored_hole(d_through, d_cbore, cbore_depth, total_h) {
    union() {
        cylinder(h = total_h + 0.2, d = d_through, center = false);
        translate([0, 0, total_h - cbore_depth])
            cylinder(h = cbore_depth + 0.1, d = d_cbore);
    }
}

module base_flange() {
    difference() {
        cube([length, depth, thickness]);

        // grid of counterbored holes in the base
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
        cube([length, thickness, height]);

        // holes in the vertical leg
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
        // inner fillet
        translate([0, 0, 0])
            rounded_inner_corner(fillet_radius, thickness, length);
        if (rib_enabled) rib();
    }
}

bracket();

// ------------------------------------------------------------
// echo summary so the terminal log doubles as a parts list
echo("=== Parametric Bracket ===");
echo(length=length, depth=depth, height=height, thickness=thickness);
echo(base_holes=hole_count_base, leg_holes=hole_count_vertical);
echo(approx_volume_cm3 = (length*depth*thickness + length*thickness*height)/1000);
