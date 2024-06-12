//Holder for 2x18650 batteries with hole raster to be mounted onto camera cage
bissl = 1 / 100;
$fn = 64 / 1;

wall = 1.6;
contact_width = 1.6;
contact_depth = 1.6;
battery_d = 19;
battery_l = 64;

use<include/battery_holder_double_spring.scad>
difference() {
  holders(battery_l=battery_l, battery_d=battery_d, wall=wall, contact_depth=contact_depth, contact_width=contact_width, n=2);
  for (x = [13.5:20:60])
    for (y = [11:20:31])
      translate([ x, y, -bissl ]) cylinder(d1 = 6, d2 = 10, h = 2);
}