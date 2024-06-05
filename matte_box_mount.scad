use<rod_mounts.scad>
bissl = 1 / 100;
$fs = 1 / 2;
$fa = 1 / 1;
larger_d = 84;
smaller_d = 80;
inner_d = 75;
larger_thickness = 1.6;
thickness = 6;
offset = 85;
wiggle_room = 10;
rods_distance = 60;
rod_d = 15;
wall = 3;
width = 31;
free_space_depth = 3;
free_space_diameter = 106;
hole_d = 4.5;
nut_d = 8;
nut_h = 4;
difference() {
  union() {
    cylinder(d = 70, h = thickness + 1.5 + 2);
    translate([ 0, 0, thickness ]) cylinder(h = 2, d1 = 70, d2 = 74);
    rotate([ 0, 0, 180 - atan(rods_distance / offset / 2) ])
        translate([ -rod_d / 2 - wall, 0, 0 ]) cube([
          rod_d + 2 * wall, norm([ offset, rods_distance / 2 ]), thickness + 2 * bissl]);
    rotate([ 0, 0, 180 + atan(rods_distance / offset / 2) ])
        translate([ -rod_d / 2 - wall, 0, 0 ]) cube([
          rod_d + 2 * wall, norm([ offset, rods_distance / 2 ]), thickness + 2 * bissl]);
  }
  for (m = [ [ 0, 0, 0 ], [ 1, 0, 0 ] ])
    mirror(m) translate([ rods_distance / 2, -offset, 5 ]) rotate([ -90, 0, 0 ])
        clamp(rod_d = rod_d, depth = 10, wall = wall, nut_h = nut_h,
              nut_d = nut_d, hole_d = hole_d, offset = 0, negative = true);
  translate([ 0, 0, -bissl ])
      cylinder(d = 65, h = thickness + 1.5 + 2 + 2 * bissl);
  for (m = [ [ 0, 0, 0 ], [ 1, 0, 0 ] ])
    mirror(m) translate([ -rods_distance / 2, -offset, -bissl ])
        cylinder(d = rod_d + 2 * wall, h = thickness + 2 * bissl);
}
for (m = [ [ 0, 0, 0 ], [ 1, 0, 0 ] ])
  mirror(m) translate([ rods_distance / 2, -offset, 5 ]) rotate([ -90, 0, 0 ])
      clamp(rod_d = rod_d, depth = 10, wall = wall, nut_h = nut_h,
            nut_d = nut_d, hole_d = hole_d, offset = 0);