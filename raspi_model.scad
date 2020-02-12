

module pi_board_holes(pi_dims, hole_positions, hole_diameter, fn) {
    echo(hole_diameter);
    for( pos = hole_positions)
        translate([pos[0], pos[1], pos[2]]) 
            cylinder(d=hole_diameter, h=pos[2], $fn=fn);
}

module pi_board(pi_dims, corner_radius, pi_hole_positions, hole_diameter, fn) {
    x = pi_dims[0]/2 - corner_radius;
    y = pi_dims[1]/2 - corner_radius;
//    translate([0, 0, pi_dims[2]/2])
        difference(){
            hull() {
                translate([ x, y, 0]) cylinder(r=corner_radius, h=pi_dims[2], $fn=fn);
                translate([-x, y, 0]) cylinder(r=corner_radius, h=pi_dims[2], $fn=fn);
                translate([ x,-y, 0]) cylinder(r=corner_radius, h=pi_dims[2], $fn=fn);
                translate([-x,-y, 0]) cylinder(r=corner_radius, h=pi_dims[2], $fn=fn);
            }
            pi_board_holes(pi_dims, pi_hole_positions, hole_diameter, fn);
        };
}

module pi_top_posts(hole_positions, post_h, post_d, hole_d, fn) {
    for( pos = hole_positions)
        translate([pos[0], pos[1], pos[2]]) 
            difference(){
                cylinder(d=post_d, h=post_h, $fn=fn);
                cylinder(d=hole_d, h=post_h, $fn=fn);
            };
}

module usb_plug() {
    cube([13.3, 17.0, 13.1]);
}

module eth_plug() {
    cube([16.0, 21.3, 14.0]);
}

module hdmi_socket() {
    cube([12.1, 15.0, 5.6]);
}

module ribbon_socket() {
    cube([22.35, 3.0, 7.55]);
}

module audio_socket() {
    cube([12.8, 7.7, 7.7]);
    translate([12.8, 3.85, 3.85])
        rotate([0, 90, 0])
            cylinder(d=7.7, h=2.2);
}

module forty_pin_header() {
    cube([5.0, 50.5, 8.5]);
}

// params
function pi_post_diameter() = 5.2;
function pi_top_post_height() = 15.0;
function pi_dims() = [56.0, 85.0, 1.5];
function pi_corner_radius() = 2.0;
function pi_hole_margin_inset() = 3.4;
function pi_hole_diameter() = 2.4;
function pi_hole_positions() = [
    [ 24.6,-39.1, 1.5],
    [-24.6,-39.1, 1.5],
    [ 24.6, 19.1, 1.5],
    [-24.6, 19.1, 1.5]
];

module pi_assembly() {
    fn = 20;

    pi_board(pi_dims(), pi_corner_radius(), pi_hole_positions(), pi_hole_diameter(), fn);

    translate([  -25.0, 27.5, 1.5]) usb_plug();
    translate([  -7.0,  27.5, 1.5]) usb_plug();
    translate([  10.0,  23.5, 1.5]) eth_plug();
    translate([  18.0, -22.0, 1.5]) hdmi_socket();
    translate([   5.5,  -1.5, 1.5]) ribbon_socket();
    translate([ -11.0, -41.5, 1.5]) ribbon_socket();
    translate([  15.0, 5.5, 1.5]) audio_socket();
    translate([   -27,  -35.5, 1.5]) forty_pin_header();

    pi_top_posts(
        pi_hole_positions(),
        pi_top_post_height(),
        pi_post_diameter(),
        pi_hole_diameter(), fn);
}

pi_assembly();
