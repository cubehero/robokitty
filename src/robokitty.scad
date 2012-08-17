use <parts.scad>
use <rounded.scad>

body_h = 40;
body_r = 25;
leg_h = 35;
leg_r = 10;
joint_r = leg_r / 2;

head_zoff = 1.2 * body_h;
head_xy = 1.4 * body_r;
head_z = 1.2 * body_r;
head_shift = 0.4 * head_xy;

ear_zoff = head_z;
ear_xoff = head_xy / 3;
ear_yoff = head_xy / 4;

// relative to head
face_offy = -head_xy / 2;
face_offz = 0.5 * head_z;

// relative to face
visor_offz = 0.05 * head_z;
nose_offz = -0.1 * head_z;

tol = 0.01;

module ear(r = 12) {
  intersection() {
    translate([r / 2, 0, 0]) sphere(r);
    translate([-r / 2, 0, 0]) sphere(r);
    translate([-r, 0, -r]) cube(2 * r);
  }
}

module visor() {
  // visor
  translate([0, 0, visor_offz])
    hull() {
      translate([0.3 * head_xy, 0, 0]) sphere(3);
      translate([-0.3 * head_xy, 0, 0]) sphere(3);
    }
}

module face() {
  translate([0, 0, nose_offz]) sphere(2.5);
  translate([0, 0, nose_offz]) mirror([0, 0, 1]) cylinder(0.3 * head_z, r = 1);
  
  translate([0, 0, nose_offz]) rotate([90, 0, 0])
    intersection() {
      mirror([0, 1, 0]) translate([-head_z / 2, head_z / 8, -head_z / 2])
        cube([head_z, head_z, head_z]);
      torus(0.3 * head_z, 1);
    }
  
}

module head() {

  translate([0, -head_shift, 0]) {
    difference() {
      union() {
        translate([-head_xy / 2, -head_xy / 2, 0])
          rounded_cube([head_xy, head_xy, head_z], r = 4);
        translate([ear_xoff, -ear_yoff, ear_zoff - tol])
          rotate([0, 30, 0]) ear(18);
        translate([-ear_xoff, -ear_yoff, ear_zoff - tol])
          rotate([0, -30, 0]) ear(18);
        translate([0, face_offy, face_offz]) visor();
      }
      translate([0, face_offy, face_offz]) face();
    }
  }
}

module body() {
  cylinder(body_h, r = body_r);
  translate([0, 0, body_h]) sphere(body_r);
}

module leg() {
  intersection() {
    union() {
      // thigh
      cylinder(leg_h - joint_r, r = joint_r);
      translate([0, 0, leg_h - joint_r]) sphere(joint_r);

      // paw
      translate([joint_r * cos(-90), joint_r * sin(-90), 0]) sphere(joint_r);
      translate([joint_r * cos(-45), joint_r * sin(-45), 0]) sphere(joint_r);
      translate([joint_r * cos(0), joint_r * sin(0), 0]) sphere(joint_r);
    }
    cylinder(leg_h, r = leg_r);
  }
}

module robokitty() {
  body();
  translate([0, 0, head_zoff]) {
    head();
  }
  translate([body_r * cos(-60), body_r * sin(-60), 0])
    leg();
  translate([body_r * cos(-120), body_r * sin(-120), 0])
    mirror([1, 0, 0]) leg();
}

robokitty();
