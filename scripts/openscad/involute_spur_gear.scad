// ============================================================
// Involute Spur / Helical Gear Generator
// Author: Katherine Feemster
// License: MIT
//
// Generates a true involute spur gear (or helical when helix_angle > 0).
// Parameters follow ISO 21771 naming where possible.
// ============================================================

/* [Gear parameters] */
module_mm       = 2.0;   // ISO module (mm per tooth)
teeth           = 24;    // number of teeth, z
pressure_angle  = 20;    // degrees, standard
face_width      = 12;    // axial thickness, mm
helix_angle     = 0;     // 0 = spur, try 15 for helical
bore_diameter   = 10;
hub_diameter    = 22;
hub_length      = 18;

/* [Profile quality] */
involute_steps  = 16;    // samples per involute flank
$fn             = 96;

// ------------------------------------------------------------
// Derived
pitch_diameter   = module_mm * teeth;
base_diameter    = pitch_diameter * cos(pressure_angle);
addendum         = module_mm;
dedendum         = 1.25 * module_mm;
outside_diameter = pitch_diameter + 2*addendum;
root_diameter    = max(pitch_diameter - 2*dedendum, base_diameter - 0.5);

// involute function (a in degrees) — returns an angle in radians
function inv_rad(a_deg) = tan(a_deg) - a_deg*PI/180;

// Parametric involute point on a base circle of radius rb, parameter t in degrees
function inv_pt(rb, t_deg) = [
    rb*(cos(t_deg) + t_deg*PI/180 * sin(t_deg)),
    rb*(sin(t_deg) - t_deg*PI/180 * cos(t_deg))
];

function rot_pt(p, ang) = [
    p[0]*cos(ang) - p[1]*sin(ang),
    p[0]*sin(ang) + p[1]*cos(ang)
];

// One tooth: a closed polygon from root-right → involute-right-up →
// tip-arc → involute-left-down → root-left.
module tooth_2d() {
    rb = base_diameter/2;
    ra = outside_diameter/2;
    rr = root_diameter/2;

    // parameter where the involute reaches the outside circle
    t_max = sqrt(max(pow(ra/rb, 2) - 1, 0)) * 180/PI;

    // tooth half-thickness angle at the pitch circle (degrees)
    half_pitch = 360/(4*teeth);  // = 90/teeth

    // Align the involute so that it crosses the pitch circle at +half_pitch
    // (right flank) and -half_pitch (left flank).
    // Angle at pitch circle on a raw involute rooted at t=0 is inv(pressure_angle).
    inv_pa_deg = inv_rad(pressure_angle) * 180/PI;
    align      = half_pitch + inv_pa_deg;

    // Right flank: involute from base to tip, then rotated by -align
    right_flank = [
        for (i = [0 : involute_steps])
            let (t = i * t_max / involute_steps)
                rot_pt(inv_pt(rb, t), -align)
    ];

    // Left flank: mirror of the right flank (y -> -y), rotated by +align,
    // walked top→bottom so the polygon stays consistent.
    left_flank = [
        for (i = [involute_steps : -1 : 0])
            let (t = i * t_max / involute_steps,
                 p = inv_pt(rb, t),
                 m = [p[0], -p[1]])
                rot_pt(m, align)
    ];

    // Root arc connecting the two flanks on the bottom (small sweep)
    // so the polygon has a smooth base rather than a sharp pinch.
    root_sweep = half_pitch * 0.8;
    root_arc = [
        for (a = [-root_sweep : root_sweep/4 : root_sweep])
            [rr*cos(a - 180/teeth + 180/teeth), rr*sin(a)]
    ];
    // simpler: straight radial feet at the base of each flank
    root_right = [ rr*cos(-align), rr*sin(-align) ];
    root_left  = [ rr*cos( align), rr*sin( align) ];

    polygon(points = concat([root_right], right_flank, left_flank, [root_left]));
}

module gear_2d() {
    union() {
        // Root disk — everything below the dedendum circle is solid
        circle(r = root_diameter/2);
        // Teeth
        for (i = [0 : teeth - 1])
            rotate([0, 0, i * 360/teeth])
                tooth_2d();
    }
}

module gear_3d() {
    difference() {
        union() {
            linear_extrude(
                height = face_width,
                twist  = -helix_angle * face_width /
                          (PI * pitch_diameter) * 180,
                slices = max(1, floor(face_width/2)),
                convexity = 10
            ) gear_2d();

            // Hub above the gear body
            translate([0, 0, face_width])
                cylinder(h = max(hub_length - face_width, 0.1),
                         d = hub_diameter);
        }

        // Through bore
        translate([0, 0, -0.1])
            cylinder(h = hub_length + 0.2, d = bore_diameter);
    }
}

gear_3d();

echo("=== Involute Gear ===");
echo(module_mm=module_mm, teeth=teeth, pressure_angle=pressure_angle);
echo(pitch_d=pitch_diameter, outside_d=outside_diameter, root_d=root_diameter);
