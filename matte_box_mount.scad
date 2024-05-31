use<tube_clamps.scad>
bissl=1/100;
$fs=1/2;
$fa=1/1;
larger_d=84;
smaller_d=80;
inner_d=75;
larger_thickness=1.6;
thickness=6;
offset=85;
wiggle_room=10;
rods_distance=60;
rod_diameter=15;
wall=3;
width=31;
free_space_depth=3;
free_space_diameter=106;
d_bolt=4.5;
difference() {
  union() {
    cylinder(d=70,h=thickness+1.5+2);
    translate([0,0,thickness])cylinder(h=2,d1=70,d2=74);
    hull() {
    cylinder(d=rod_diameter+2*wall,h=thickness+2*bissl);
    translate([-rods_distance/2,-offset,0])cylinder(d=rod_diameter+2*wall,h=thickness);
    }
    hull() {
    cylinder(d=rod_diameter+2*wall,h=thickness+2*bissl);
    translate([rods_distance/2,-offset,0])cylinder(d=rod_diameter+2*wall,h=thickness);
    }
 }
  translate([0,0,-bissl]) cylinder(d=65,h=thickness+1.5+2+2*bissl);
  for (m=[[0,0,0],[1,0,0]]) mirror(m)translate([-rods_distance/2,-offset,-bissl])cylinder(d=rod_diameter+2*wall,h=thickness+2*bissl);  
}
for (m=[[0,0,0],[1,0,0]]) mirror(m)translate([-rods_distance/2,-offset,5])rotate([0,0,90])clamp(d_tube = rod_diameter, h_ring = 10, wall = wall, d_bolt = d_bolt,
        offset = 1, nut = true, d_nut = 2*d_bolt, coupling = false,
        bcd = 0, n_screws = 0, d_circle = 0); 
