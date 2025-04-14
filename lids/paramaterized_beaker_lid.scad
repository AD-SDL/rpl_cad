grommet_radius = 2.1;
lid_radius = 45;
lid_height = 10;
lip_offset = 1;
lip_width = 1;

$fn=100;

difference() {
    cylinder(h=lid_height, r = lid_radius, center = true); //lid body
    cylinder(h=lid_height + 1, r = grommet_radius, center = true); // grommet hole
    translate([0, 0, lip_offset]) cylinder(h=lid_height, r = lid_radius - lip_width, center = true); // hollow out body for lip
}
