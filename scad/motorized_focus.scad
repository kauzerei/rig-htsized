use <include/publicDomainGearV1.1.scad>
$fa = 1 / 1;
$fs = 1 / 2;
bissl = 1 / 100;

part = "motor_bracket"; //[motor_bracket,motor_cover,motor_gear,external_gear,NOSTL_assembly]

motor_width = 35.3;
motor_mount_square = 26;
motor_mount_d = 3.5; // added +0.5 tolerance
motor_axle = 5;
motor_cylinder_h = 2;
motor_cylinder_d = 23; // added +1 tolerance

bearing_id = 8;
bearing_od = 22;
bearing_h = 7;

hole_d = 4.5;
nut_d = 8;
nut_h = 4;
part_depth = 10;
step_h = (part_depth - bearing_h) / 2;
step_w = 1.6;
wall = 1.6;

gear_module = 0.8;
total_teeth = floor(motor_mount_square * sqrt(2) / gear_module);
axial_distance = total_teeth * gear_module / 2;
teeth_motor = 12;
teeth_offset = total_teeth - teeth_motor;

module motor_bracket() {
  difference() {
    cube([ motor_width, motor_width, part_depth + wall ], center = true);
    for (m = [ [ 1, 0, 0 ], [ 1, 1, 0 ], [ 0, 1, 0 ], [ 0, 0, 0 ] ])
      mirror(m) translate([ motor_mount_square / 2, motor_mount_square / 2, 0 ])
          cylinder(d = motor_mount_d, h = part_depth + wall + bissl, center = true);
    cylinder(d = motor_cylinder_d, h = part_depth + wall + bissl, center = true);
    translate([
      motor_mount_square / 2 - nut_d / 2 - motor_mount_d / 2,
      -motor_cylinder_d / 2 - nut_h, wall / 2
    ]) rotate([ -90, 0, 0 ])
        cylinder(d = nut_d, h = motor_cylinder_d / 2 + nut_h, $fn = 6);
    translate([
      motor_mount_square / 2 - nut_d / 2 - motor_mount_d / 2,
      -motor_width / 2 - bissl, wall / 2
    ]) rotate([ -90, 0, 0 ]) cylinder(d = hole_d, h = motor_width / 2);
    translate([
      -motor_mount_square / 2 + nut_d / 2 + motor_mount_d / 2,
      -motor_cylinder_d / 2 - nut_h, wall / 2
    ]) rotate([ -90, 0, 0 ])
        cylinder(d = nut_d, h = motor_cylinder_d / 2 + nut_h, $fn = 6);
    translate([
      -motor_mount_square / 2 + nut_d / 2 + motor_mount_d / 2,
      -motor_width / 2 - bissl, wall / 2
    ]) rotate([ -90, 0, 0 ]) cylinder(d = hole_d, motor_width / 2);
    difference() {
      translate([ part_depth, part_depth, wall ])
          cube([ motor_width, motor_width, part_depth + wall ], center = true);
      translate([
        axial_distance * sqrt(0.5), axial_distance * sqrt(0.5),
        -(part_depth + wall) / 2
      ]) cylinder(d = bearing_id + 2 * step_w, h = wall + step_h);
      translate([
        axial_distance * sqrt(0.5), axial_distance * sqrt(0.5),
        -(part_depth + wall) / 2
      ]) cylinder(d = bearing_id, h = 2 * wall + step_h);
    }
  }
}

module motor_cover() {
  difference() {
    cube([ motor_width, motor_width, 2 * wall + step_h ], center = true);
    for (m = [ [ 1, 0, 0 ], [ 1, 1, 0 ], [ 0, 1, 0 ], [ 0, 0, 0 ] ])
      mirror(m) translate([ motor_mount_square / 2, motor_mount_square / 2, 0 ])
          cylinder(d = motor_mount_d, h = 2 * wall + step_h + bissl, center = true);
    cylinder(d = motor_cylinder_d, h = 2 * wall + step_h + bissl, center = true);
    difference() {
      translate([ 0, 0, wall ])
          cube([ motor_width + bissl, motor_width + bissl, 2 * wall + step_h ], center = true);
      translate([
        axial_distance * sqrt(0.5), axial_distance * sqrt(0.5),
        -(2 * wall + step_h) / 2
      ]) cylinder(d = bearing_id + 2 * step_w, h = wall + step_h);
      translate([
        axial_distance * sqrt(0.5), axial_distance * sqrt(0.5),
        -(2 * wall + step_h) / 2
      ]) cylinder(d = bearing_id, h = 2 * wall + step_h);
    }
  }
}

if (part == "motor_bracket")
  motor_bracket();
if (part == "motor_cover")
  motor_cover();
if (part == "motor_gear")
  gear(0.8 * 3.1415926, teeth_motor, part_depth, 5);
if (part == "external_gear")
  gear(0.8 * 3.1415926, teeth_offset, part_depth - 1, bearing_od);
if (part == "NOSTL_assembly") {
  translate([ 0, 0, part_depth / 2 - (part_depth + wall) / 2 ]) motor_bracket();
  translate([ 0, 0, part_depth / 2 + wall - (2 * wall + step_h) / 2 ])
      mirror([ 0, 0, 1 ]) motor_cover();
  gear(0.8 * 3.1415926, teeth_motor, part_depth, 5);
  translate([ axial_distance * sqrt(0.5), axial_distance * sqrt(0.5), 0 ])
      gear(0.8 * 3.1415926, teeth_offset, part_depth - 1, bearing_od);
}