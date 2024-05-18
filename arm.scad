// Arm with rosette on one side and tube mount on the other
// For mounting monitor on the tube parallel to it

$fa = 1 / 1;
$fs = 1 / 2;
d_tube = 16;
wall = 3;
bolt_d = 4;
nut_d = 9;
bolt_offset = 30;
mount_offset = 50;
part_width = 10;
raster = 10;
bissl = 1 / 100;
alot = 200;

module hole(bolt_d=bolt_d, nut_d=nut_d, wall = wall, depth = depth) {
  translate([ 0, 0, -bissl ]) cylinder(d = bolt_d, h = alot);
  translate([ 0, 0, -bissl ]) cylinder(d = nut_d, h = wall - depth, $fn = 6);
}

module arm() {
  difference() {
    union() {
      translate([ -mount_offset + wall + d_tube / 2, 0, 0 ]) rotate([ 0, 0, 0 ])
          cylinder(h = part_width, d = 2 * raster + 2 * bolt_d + wall,
                   center = true);
      hull() {
        translate([ d_tube / 2 + wall, 0, 0 ])
            cylinder(h = part_width, d = d_tube + 2 * wall, center = true);
        translate([ -mount_offset + wall + d_tube / 2, 0, 0 ])
            rotate([ 0, 0, 0 ])
                cylinder(h = part_width, d = d_tube + 2 * wall, center = true);
      }
    }
    translate([ d_tube / 2 + wall, 0, 0 ])
        cylinder(h = part_width + bissl, d = d_tube, center = true);
    translate([ 0, 0, 0 ]) rotate([ 90, 0, 0 ])
        cylinder(h = d_tube + 2 * wall + bissl, d = bolt_d, center = true);
    translate([ 0, -d_tube / 2, 0 ]) rotate([ 90, 0, 0 ])
        cylinder(h = d_tube + 2 * wall + bissl, d = nut_d, $fn = 6);
    translate([ -mount_offset + wall + d_tube / 2, 0, 0 ])
        rosette_mount_holes(wall = part_width, depth = wall, raster = raster);
    hull() {
      translate([ -mount_offset + wall + d_tube + d_tube / 2, 0, 0 ]) cylinder(
          h = part_width + bissl, d = d_tube - 2 * wall, center = true);
      translate([ d_tube / 2 + wall, 0, 0 ]) cylinder(
          h = part_width + bissl, d = d_tube - 2 * wall, center = true);
    }
  }
}

module rosette_mount_holes(wall = 10, depth = 2, raster = 10) {
  for (angle = [45:90:360])
    translate([ raster * cos(angle), raster * sin(angle), -part_width / 2 ])
        hole(wall = wall, depth = depth);
  translate([ 0, 0, -part_width / 2 ]) hole(wall = wall, depth = depth);
}

rotate([180,0,0])arm();