
cap_radius = 25.5;
cap_hole_radius = 2.5;
cap_hole_clearance = 4.5;

cap_rim_radius = 34.5;

base_bottom_radius = 34;
base_can_height = 80;
base_screw_radius = 1.5;

fn=90;

module cap_base() {
    hull() {
        difference() {
            rotate_extrude(convexity = 1, $fn = fn)
                translate([cap_radius,0,0])
                    circle(r=9);
            translate([0,0,-5])cube([100,100, 10], center = true);
        }
    }    
}

module cap_holes() {
    // through holes
    depth = 60;
    translate([cap_radius, 0, -depth]) cylinder(h=depth+20, r=base_screw_radius, $fn=fn);
    rotate([0, 0, 120]) translate([cap_radius, 0, -depth]) cylinder(h=depth+20, r=base_screw_radius, $fn=fn);
    rotate([0, 0,-120]) translate([cap_radius, 0, -depth]) cylinder(h=depth+20, r=base_screw_radius, $fn=fn);
    
    // screw-head clearance
    translate([cap_radius, 0, 4]) cylinder(h=6, r=cap_hole_clearance, $fn=fn);
    rotate([0, 0, 120]) translate([cap_radius, 0, 4]) cylinder(h=6, r=cap_hole_clearance, $fn=fn);
    rotate([0, 0,-120]) translate([cap_radius, 0, 4]) cylinder(h=6, r=cap_hole_clearance, $fn=fn);
}

module cap_assembly() {
    difference() {
        cap_base();
        cap_holes();
    }
}

module base_can() {
    depth = 30;

    
    difference() {
        union(){
            // outer cylinder
            translate([0,0,-base_can_height])
                cylinder(
                    h=base_can_height,
                    r1=base_bottom_radius,
                    r2=base_bottom_radius+5, $fn=fn);

            // sleeves
            translate([cap_radius, 0, -depth])
                cylinder(h=depth+5,
                r1=cap_hole_radius,
                r2=cap_hole_radius-.5, $fn=fn);

            rotate([0, 0, 120])
                translate([cap_radius, 0, -depth])
                    cylinder(h=depth+3,
                            r1=cap_hole_radius,
                            r2=cap_hole_radius-.5,
                            $fn=fn);

            rotate([0, 0,-120])
                translate([cap_radius, 0, -depth])
                    cylinder(h=depth+3,
                            r1=cap_hole_radius,
                            r2=cap_hole_radius-.5,
                            $fn=fn);
        }
        
        union() {
            translate([0,0,-base_can_height])
                cylinder(h=base_can_height, r1=base_bottom_radius-6, r2=cap_rim_radius-12, $fn=fn);
            cap_holes();
        }
    }
}

//cap_assembly();
base_can();


