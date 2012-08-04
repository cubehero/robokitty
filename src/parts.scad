/* Basic elementary shapes and negative space */

module ring(height, inner_radius, outer_radius) {
  difference() {
    cylinder(height, outer_radius, outer_radius);
    cylinder(height, inner_radius, inner_radius);
  }
} 
// ring(10, 8, 12);
 
module torus(hole_radius = 10, solid_radius = 5, center = true) {
  module shape(hole_radius, solid_radius) {
    rotate_extrude(convexity = 10)
      translate([hole_radius, 0, 0])
        circle(solid_radius);
  }
  if (center == true) {
    shape(hole_radius, solid_radius);
  } else {
    translate([0, 0, solid_radius]) shape(hole_radius, solid_radius);
  }
}
// torus(15, 5);

module countersunk_ring(height, countersink_radii, outer_radius) {
  difference() {
    cylinder(height, outer_radius, outer_radius);
    cylinder(height, countersink_radii[0], countersink_radii[1]);
  }
 
}

module groove(height, inner_radius, offset) {
  difference() {
    child(0);
    translate([0, 0, offset]) {
      ring(height, inner_radius, 2 * inner_radius);
    }
  }
}
// groove(3, 5, 5) cylinder(10, 6, 6);

module toytop(height, radius) {
  cylinder(height / 2, radius, 0);
  translate([0, 0, -height / 2]) cylinder(height / 2, 0, radius);
}

module saucer(height, radius, inner_radius) {
  slice_height = height_of_cone_slice(radius, height / 2, inner_radius);

  difference() {
    toytop(height, radius);
    for (i = [0 : 1]) {
      mirror([0, 0, i]) 
        translate([0, 0, slice_height]) 
          cylinder(height, inner_radius, inner_radius);
    }
  }
}
// saucer(8, 10, 5);

module teardrop(head_ratio, radius) {
  theta = asin(head_ratio);
  r = radius * cos(theta);
  h = r * tan(90 - theta);

  sphere(radius);
  translate([0, 0, radius * head_ratio]) {
    cylinder(h, r, 0);
    translate([0, 0, 1.1 * h]) child(0);
  }
}
// teardrop(0.5, 10);

// creates a cylinder with rounded corners
module rounded_cylinder(h, r1, r2, rc = 4, r = -1) {
  tolerance = 0.03;
  module shape(h, r1, r2) {
    hull() {
      translate([0, 0, -tolerance])
        torus(r1 - rc, rc, center = false);
      translate([0, 0, h - rc + tolerance])
        torus(r2 - rc, rc);
    }
  }
  if (r == -1) {
    shape(h, r1, r2);
  } else {
    shape(h, r, r);
  }
}
// rounded_cylinder(15, 15, 20);
// translate([50, 0, 0]) cylinder(15, 15, 20);
// translate([100, 0, 0])
//   difference() {
//     cylinder(15, 15, 20);
//     rounded_cylinder(15, 15, 20);
//   }

/* calculates the radius of a circle cross-section if we took a slice of a sphere
 * height has to be less than radius 
 */
function radius_of_sphere_slice(radius, slice_height) = 
  radius * cos(asin(slice_height / radius));

/* calculate the height from midpoint of circle cross-section if we took a slice of 
 * a sphere */
function height_of_sphere_slice(radius, slice_radius) = 
  radius * sin(acos(slice_radius / radius));

/* calculates the radius of a perpendicular slice of a cone given the slice height */
function radius_of_cone_slice(radius, cone_height, slice_height) = 
  radius * (1 - slice_height / cone_height);

/* calculates the height of a perpendicular slice of a cone given the slice radius */
function height_of_cone_slice(radius, cone_height, slice_radius) = 
  cone_height * (1 - slice_radius / radius);

