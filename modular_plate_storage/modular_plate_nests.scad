

// Labware Properties
microplate_length = 127.76;
microplate_width = 85.48;
microplate_height = 14.5;
microplate_fit_tolerance = 0.1;

// Gripper Parameters
gripper_width = 142.20;
gripper_height = 15.0;
gripper_width_tolerance = 10.0;

// Nest Properties
nest_thickness = 4.0;
nest_extra_width = 10;

// Support Properties
support_size = 25;
support_tolerance = .75;

// Speedhole Properties
speedhole_diameter = microplate_width / 4;
length_speedhole_spacing = speedhole_diameter * 1.15;
width_speedhole_spacing = speedhole_diameter * 1.25;

// Footing Properties
footing_radius = 25.0;
footing_height = nest_thickness;


include <8020parts/40-4040.scad>

G8020OUTERONLY = true;

module microplate(height = microplate_height) {
    cube([microplate_length, microplate_width, height], center=true);
}

module prism(l, w, h){
  polyhedron(
      points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
      faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
  );
}

module nest_corner() {
    module nest_edge() {
        union() {
            prism(19, 2.5, 5);
            translate([0, 2.5, 0]) cube([19, 2.5, 5]);
        };
    }
    color("OrangeRed") translate(
    [
        - (microplate_length / 2 + microplate_fit_tolerance),
        - (microplate_width / 2 + microplate_fit_tolerance),
        nest_thickness / 2
    ])
    union() {
        rotate([0, 0, 180]) translate([-14, 0, 0]) nest_edge();
        translate([0, -5, 0]) rotate([0, 0, 90]) nest_edge();
    }
}

module support_cutout() {
    minkowski() {
        scale([.5, .5, 1]) item40_4040(nest_thickness * 2);
        cube([support_tolerance, support_tolerance, nest_thickness * 2], center = true);
    }
}

module nest_bottom() {
    color("DarkGray") cube(
        [
            microplate_length + nest_extra_width,
            microplate_width + nest_extra_width,
            nest_thickness
        ],
        center = true
    );
}

module corner_support() {
    color("DarkGray") difference() {
        hull() {
            cube(
                [
                    support_size,
                    support_size,
                    nest_thickness
                ],
                center = true
            );
            translate([
                gripper_width / 2 + gripper_width_tolerance + support_size / 2,
                gripper_width / 2 + gripper_width_tolerance + support_size / 2,
                0
            ]) cube(
                [
                    support_size,
                    support_size,
                    nest_thickness
                ],
                center = true
            );
        };
        translate([
            gripper_width / 2 + gripper_width_tolerance,
            gripper_width / 2 + gripper_width_tolerance,
            nest_thickness /2
        ]) support_cutout();
        // Speed Hole
        translate([
            gripper_width / 2 + gripper_width_tolerance / 2 - 10,
            gripper_width / 2 + gripper_width_tolerance / 2 - 10,
            0
        ]) speed_hole();
    }
}

module corner_grip_point() {
    color("Green") 
    translate([
        microplate_length / 2 + 5 - support_size / 2,
        microplate_width / 2 + 5 + support_size / 2,
        0
    ])
    cube([support_size, support_size, nest_thickness], center=true);
    color("Green") 
    translate([
        microplate_length / 2 + 5 + support_size / 2,
        microplate_width / 2 + 5 - support_size / 2,
        0
    ])
    cube([support_size, support_size, nest_thickness], center=true);
}

module speed_hole() {
    cylinder(h = nest_thickness + 0.1, d = speedhole_diameter, center = true);
}


////4-corner Extrusion-supported
//%color("Teal") translate([0, 0, nest_thickness / 2 + microplate_height / 2]) microplate();
//difference() {
//    union() {
//        nest_bottom();
//        corner_support();
//        mirror([1, 0, 0]) corner_support();
//        mirror([1, 1, 0]) corner_support();
//        mirror([0, 1, 0]) corner_support();
//        nest_corner();
//        mirror([1, 0, 0]) nest_corner();
//        mirror([1, 0, 0]) mirror([0, 1, 0]) nest_corner();
//        mirror([0, 1, 0]) nest_corner();
//    }
//    // Speed Holes
//    for (j = [-2:2]) {
//        translate([j * length_speedhole_spacing, 0, 0]) for(i = [-1:1]) {
//                translate([0, i * width_speedhole_spacing, 0]) speed_hole();
//        }
//    }
//}

////Test Fit Piece for Extrusions
//difference() {
//    union() {
//        cube([support_size, support_size, support_size], center=true);
//        translate(
//            [-support_size, 0, (support_size - footing_height) / 2]) cube([support_size, support_size, footing_height], center=true);
//        translate(
//            [0, support_size, (support_size - footing_height) / 2]) cube([support_size, support_size, footing_height], center=true);
//    }
//    scale([1, 1, 10]) translate([-10, -10, 0]) support_cutout();
//}

//Lid Nest
%color("Teal") translate([0, 0, nest_thickness / 2 + microplate_height / 2]) microplate();
difference() {
    union() {
        nest_bottom();
        corner_grip_point();
        mirror([1, 0, 0]) corner_grip_point();
        mirror([0, 1, 0]) mirror([1, 0, 0]) corner_grip_point();
        mirror([0, 1, 0]) corner_grip_point();
        nest_corner();
        mirror([1, 0, 0]) nest_corner();
        mirror([1, 0, 0]) mirror([0, 1, 0]) nest_corner();
        mirror([0, 1, 0]) nest_corner();
    }
    // Speed Holes
    for (j = [-2:2]) {
        translate([j * length_speedhole_spacing, 0, 0]) for(i = [-1:1]) {
                translate([0, i * width_speedhole_spacing, 0]) speed_hole();
        }
    }
}
