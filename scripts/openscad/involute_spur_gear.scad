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
root_diameter    = pitch_diameter - 2*dedendum;

function inv(a) = tan(a) - a * PI/180;           // involute function (a in deg)
function involute_xy(rb, t) = [rb*(cos(t) + t*PI/180*sin(t)),
                               rb*(sin(t) - t*PI/180*cos(t))];

// one tooth flank as a polygon
module tooth_2d() {
    rb = base_diameter/2;
    ra = outside_diameter/2;
    // parameter t where involute reaches outside diameter
    t_max = sqrt(pow(ra/rb, 2) - 1) * 180/PI;

    // half tooth thickness angle at pitch circle
    half_tooth_angle_pitch = 90/teeth;
    // rotation to align tooth symmetrically
    align = half_tooth_angle_pitch + inv(pressure_angle)*180/PI;

    pts_right = [ for (i = [0 : involute_steps])
        let (t = i * t_max / involute_steps,
             p = involute_xy(rb, t))
        [p[0]*cos(-align) - p[1]*sin(-align),
         p[0]*sin(-align) + p[1]*cos(-align)] ];

    pts_left = [ for (i = [involute_steps : -1 : 0])
        let (t = i * t_max / involute_steps,
             p = involute_xy(rb, t),
             m = [p[0], -p[1]])
        [m[0]*cos(align) - m[1]*sin(align),
         m[0]*sin(align) + m[1]*cos(align)] ];

    root = root_diameter/2;
    root_arc = [ for (a = [-half_tooth_angle_pitch*1.2 :
                            half_tooth_angle_pitch*0.1 :
                            half_tooth_angle_pitch*1.2])
                 [root*cos(a), root*sin(a)] ];

    polygon(points = concat(root_arc, pts_right, pts_left));
}

module gear_2d() {
    union() {
        circle(d = root_diameter);
        for (i = [0 : teeth - 1])
            rotate([0, 0, i * 360/teeth]) tooth_2d();
    }
}

module gear_3d() {
    difference() {
        union() {
            linear_extrude(height = face_width,
                           twist  = -helix_angle * face_width / (PI * pitch_diameter) * 180,
                           slices = max(1, floor(face_width/2)))
                gear_2d();
            // hub
            translate([0, 0, face_width])
                cylinder(h = hub_length - face_width, d = hub_diameter);
        }
        // bore
        translate([0, 0, -0.1])
            cylinder(h = hub_length + 0.2, d = bore_diameter);
    }
}

gear_3d();

echo("=== Involute Gear ===");
echo(module_mm=module_mm, teeth=teeth, pressure_angle=pressure_angle);
echo(pitch_d=pitch_diameter, outside_d=outside_diameter, root_d=root_diameter);
