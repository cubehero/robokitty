use <parts.scad>
use <rounded.scad>

body_h = 50;
body_r = 22;

head_zoff = 1.1 * body_h;
head_xy = 2 * 0.95 * body_r;
head_z = 2 * 0.8 * body_r;

face_off = -head_xy / 2;

module head() {
  translate([-head_xy / 2, -head_xy / 2 - 0.1 * head_xy, 0])
    rounded_cube([head_xy, head_xy, head_z], r = 4);
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
