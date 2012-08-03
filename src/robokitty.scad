

module body() {
  cylinder(50, r = 22);
  translate([0, 0, 50]) sphere(22);
}

module robokitty() {
  body();
}

robokitty();
