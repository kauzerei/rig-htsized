//Holder for 2x18650 batteries with hole raster to be mounted onto camera cage
bissl = 1 / 100;
$fn = 64 / 1;

wall = 1.6;
contact_width = 1.6;
contact_depth = 1.6;
battery_d = 19;
battery_l = 64;

jack_d=12;
box_w=19;
box_l=battery_l+2*contact_depth;
switch_offset=11;
jack_offsets=[35,55];
pcb_thickness=3;

module switch_hole() {
  square([8,4],center=true);
  translate([-7.5,0]) circle(d=3);
  translate([7.5,0]) circle(d=3);
}

use<include/battery_holder_double_spring.scad>
difference() {
  holders(battery_l=battery_l, battery_d=battery_d, wall=wall, contact_depth=contact_depth, contact_width=contact_width, n=2);
  for (x = [13.5:20:60])
    for (y = [11:20:31])
      translate([ x, y, -bissl ]) cylinder(d1 = 6, d2 = 10, h = 2);
}
difference() {
  translate([-wall,-box_w-wall,0]) cube([box_l+2*wall,box_w+wall,battery_d+wall]);
  translate([0,-box_w+bissl,wall]) cube([box_l,box_w,battery_d+bissl]);
  translate([switch_offset,-box_w+2*bissl,wall+(battery_d+pcb_thickness)/2])rotate([90,0,0])linear_extrude(height=wall+3*bissl) switch_hole();
  for (offset=jack_offsets) translate([offset,-box_w+2*bissl,wall+(battery_d+pcb_thickness)/2])
                            rotate([90,0,0]) linear_extrude(height=wall+3*bissl) circle(d=jack_d);
}