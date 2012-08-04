use <parts.scad>
use <rounded.scad>

body_h = 50;
body_r = 22;

head_zoff = 1.1 * body_h;
head_xy = 2 * 0.95 * body_r;
head_z = 2 * 0.8 * body_r;

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
  head_shift = 0.1 * head_xy;

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

module robokitty() {
  body();
  translate([0, 0, head_zoff]) {
    head();
  }
}

robokitty();
