use <./raspi_model.scad>;

fn = 20;

module mount_shell(pi_dims, corner_radius, pi_hole_positions, hole_diameter, fn) {
    x = pi_dims[0]/2 - 2;
    y1 = pi_dims[1]/2 - 2;
    y2 = pi_dims[1]/2 - 21;
    h = 5;
    translate([0, 0, pi_dims[2] + 10])
        hull() {
            translate([ x,-y1, 0]) cylinder(r=corner_radius, h=h, $fn=fn);
            translate([-x,-y1, 0]) cylinder(r=corner_radius, h=h, $fn=fn);
            translate([ x, y2, 0]) cylinder(r=corner_radius, h=h, $fn=fn);
            translate([-x, y2, 0]) cylinder(r=corner_radius, h=h, $fn=fn);
        };
}

module bracket_cavity() {
    hull() {
            pi_top_posts(
                pi_hole_positions(),
                pi_top_post_height(),
                pi_post_diameter(),
                pi_hole_diameter(), fn);
        };
}

module bracket_shell() {
    difference(){
        mount_shell(
            pi_dims(),
            pi_corner_radius(),
            pi_hole_positions(),
            pi_hole_diameter(), fn);
        bracket_cavity();
    }
}

module bracket_post_sleeves() {
    height = pi_top_post_height() - 10;
    radius = pi_post_diameter()/2 + 1;
    x = pi_dims()[0]/2-radius;
    y1 = pi_dims()[1]/2 - radius;
    y2 = pi_dims()[1]/2 - radius - 19.5;
    z = height+6.5;
    translate([x, -y1, z]) cylinder(r=radius, h=height, $fn=fn);
    translate([-x,-y1, z]) cylinder(r=radius, h=height, $fn=fn);
    translate([x,  y2, z]) cylinder(r=radius, h=height, $fn=fn);
    translate([-x, y2, z]) cylinder(r=radius, h=height, $fn=fn);
}

module bracket_post_holes(hole_positions, post_h, post_d, hole_d, fn) {
    for( pos = hole_positions)
        translate([pos[0], pos[1], pos[2]]) 
            cylinder(d=post_d, h=post_h, $fn=fn);
}

module bracket_post_screw_head_facing(hole_positions, post_h, post_d, hole_d, fn) {
    for( pos = hole_positions)
        translate([pos[0], pos[1], pos[2]+post_h+2]) 
            cylinder(d=6.0, h=2, $fn=fn);
    for( pos = hole_positions)
        translate([pos[0], pos[1], pos[2]]) 
            cylinder(d=hole_d, h=post_h+5, $fn=fn);
}

module bracket_center_mount_face() {
    height = pi_top_post_height();
    radius = 2;
    x = pi_dims()[0]/2-radius;
    y1 = pi_dims()[1]/2 - radius;
    y2 = pi_dims()[1]/2 - radius - 19;

    hull() {
        translate([ x, -y1, height+1.5]) sphere(r=radius, $fn=fn);
        translate([-x, -y1, height+1.5]) sphere(r=radius, $fn=fn);
        translate([ x,  y2, height+1.5]) sphere(r=radius, $fn=fn);
        translate([-x,  y2, height+1.5]) sphere(r=radius, $fn=fn);        
        translate([-5, -15, height+10]) sphere(r=radius, $fn=fn);
    }
}

module bracket_center_mount_hole() {
    translate([-10, -15, pi_top_post_height() + 2])
        rotate([0,60,0])
            cylinder(h=22, r=3, $fn=fn);
}

module bracket_assembly() {
    difference() {
        union() {
            bracket_shell();
            bracket_post_sleeves();
            bracket_center_mount_face();    
        }
        union() {
            bracket_post_screw_head_facing(
                pi_hole_positions(),
                pi_top_post_height(),
                pi_post_diameter(),
                pi_hole_diameter(), fn);
            bracket_post_holes(
                    pi_hole_positions(),
                    pi_top_post_height(),
                    pi_post_diameter(),
                    pi_hole_diameter(), fn);
            bracket_center_mount_hole();
        }
    }
}

module full_assembly() {
    bracket_assembly();
    //pi_assembly();
}

//rotate([0, 0, $t*360])
    full_assembly();