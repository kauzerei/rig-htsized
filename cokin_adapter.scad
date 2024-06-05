bissl=1/100;
$fs=1/2;
$fa=1/1;
larger_d=85;
smaller_d=80;
inner_d=75;
larger_thickness=1.6;
total_thickness=7;
offset=85;
wiggle_room=10;
wall=3;
width=31;
free_space_depth=3;
free_space_diameter=108;
bolt_d=4.5;
raster=10;
difference() {
  union() {
    cylinder(h=larger_thickness,d=larger_d);
    cylinder(d=smaller_d,h=total_thickness);
    difference() {
      translate([-width/2,0,0])cube([width,offset+wall+wiggle_room/2+bolt_d/2,total_thickness]);
      translate([0,0,-bissl]) cylinder(d=free_space_diameter,h=free_space_depth);
      }
    }
  translate([0,0,-bissl]) cylinder(d=inner_d,h=total_thickness+2*bissl);
  for (tr=[-raster:raster:raster]) translate([tr,0,0])hull() {
  translate([0,offset+wiggle_room/2,-bissl]) cylinder(d=bolt_d,h=total_thickness+2*bissl);
  translate([0,offset-wiggle_room/2,-bissl]) cylinder(d=bolt_d,h=total_thickness+2*bissl);
  }
}