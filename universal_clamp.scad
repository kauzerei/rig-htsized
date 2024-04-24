tube=16;
wall=3;
raster=10;
part_height=16;
part_thickness=12;
rod_distance=60;
angle=30;
alot=200;
offset=1;
d_bolt=4;
module single_clamp_skew(){
width=(tube+2*wall)/cos(angle)+part_thickness*tan(angle);
  difference(){
  hull(){
    intersection() {
      rotate([angle,0,0])cylinder(d=tube+2*wall,alot,center=true);
      cube([tube+2*wall,alot,part_thickness],center=true);
    }
    translate([-(tube/2+offset+d_bolt/2),0,0])rotate([90,0,0])cylinder(d=part_thickness,h=width,center=true);
  }
      rotate([angle,0,0])cylinder(d=tube,h=alot,center=true);
      translate([-alot/2,0,0])cube([alot,tube/cos(angle)-part_thickness*tan(angle),part_thickness+1/100],center=true);
      translate([-(tube/2+offset+d_bolt/2),0,0])rotate([90,0,0])cylinder(d=d_bolt,h=width+1/100,center=true);
  }
}
module double_clamp_skew() {
single_clamp_skew();
translate([rod_distance,0,0])mirror([1,0,0])single_clamp_skew();
intersection(){
cube([alot,alot,part_thickness],center=true);
union(){
hull(){
      rotate([angle,0,0])translate([0,tube/2+wall/2,0])cylinder(d=wall,alot,center=true);
rotate([angle,0,0])translate([rod_distance,tube/2+wall/2,0])cylinder(d=wall,alot,center=true);
}
hull(){
      rotate([angle,0,0])translate([0,-tube/2-wall/2,0])cylinder(d=wall,alot,center=true);
rotate([angle,0,0])translate([rod_distance,-tube/2-wall/2,0])cylinder(d=wall,alot,center=true);
}
}
}
}
double_clamp_skew();



/*
module part_raw() {
  difference(){
  
  *union() {
    translate([-rod_distance/2,0,0])cylinder(d=tube+2*wall,h=2*tube+2*wall,center=true);
    translate([rod_distance/2,0,0])cylinder(d=tube+2*wall,h=2*tube+2*wall,center=true);
    translate([0,tube/2+wall/2,0])cube([rod_distance,wall,alot],center=true);
    translate([0,-tube/2-offset-d_bolt/2,0])cube([rod_distance+tube+2*wall,part_thickness,alot],center=true);
    }
    translate([-rod_distance/2,0,0])cylinder(d=tube,h=2*tube+2*wall,center=true);
    translate([rod_distance/2,0,0])cylinder(d=tube,h=2*tube+2*wall,center=true);
  }
}
intersection() {
  cube([alot,alot,part_height], center=true);
  part_raw();
}
  */