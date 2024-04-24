$fa=1/1;
$fs=1/1;
$fn=64;
bissl=1/100;
alot=200/1;

tube=16; //rod outer diameter
wall_round=3; //thin wall of the clamping part itself
wall=6; //thicker wall, that needs to hold nuts (of threaded inserts)
part_thickness=12; //how wide the clamping ring is
rod_distance=60; //center distance between rods
tube_to_bolt=4; //extra distance from tube to the clamping screw
skew=30; //andle at which the part is skewed

min_hole_distance=4; //from center of the hole to the wall boundaries
bolt_d=4; //hole diameter
nut_d=8; //place for inserting hexagonal nuts, corner-to-corner
depth=2; //thickness of part of the wall, that holds the nut
raster=10; //distance between rows and columns of holes

module clamp(tube,wall_round,wall,part_thickness,tube_to_bolt,bolt_d,negative=false) {
  width=(tube+2*wall_round)/cos(skew)-part_thickness*tan(skew)+bissl;
  if (!negative) {//positive part, which can be combined with other stuff
      intersection() {
        rotate([skew,0,0])cylinder(d=tube+2*wall_round,alot,center=true);
        cube([tube+2*wall_round,alot,part_thickness],center=true);
      }
      translate([-(tube/2+tube_to_bolt+bolt_d/2),0,0])rotate([90,90,0])cylinder(d=part_thickness,h=width,center=true);
      translate([-(tube/2+tube_to_bolt+bolt_d/2),-width/2,-part_thickness/2])cube([(tube/2+tube_to_bolt+bolt_d/2),width,part_thickness]);
  }
  if (negative) {//negative part, which needs to be subtracted from the combined part after intersection() of hull()
    rotate([skew,0,0])cylinder(d=tube,h=alot,center=true);
    translate([-alot/2,0,0])cube([alot,width-2*wall,part_thickness+bissl],center=true);
    translate([-(tube/2+tube_to_bolt+bolt_d/2),width/2,0])rotate([90,0,0])hole();
  }
}

module hole(wall=wall,depth=depth) {
  translate([0,0,-bissl])cylinder(d=bolt_d,h=alot);
  translate([0,0,-bissl])cylinder(d=nut_d,h=wall-depth,$fn=6);
}

module single_clamp(tube,wall_round,wall,part_thickness,tube_to_bolt,bolt_d){
  difference(){
    clamp(tube=tube,wall_round=wall_round,wall=wall,part_thickness=part_thickness,tube_to_bolt=tube_to_bolt,bolt_d=bolt_d);
    clamp(tube=tube,wall_round=wall_round,wall=wall,part_thickness=part_thickness,tube_to_bolt=tube_to_bolt,bolt_d=bolt_d,negative=true);
  }
}

module bridge(wall_bridge,nuts=true) {
  intersection(){
    cube([alot,alot,part_thickness],center=true);
     rotate([skew,0,0]) difference() {
       translate([-rod_distance/2,-tube/2-wall_round,-alot/2])cube([rod_distance,wall_bridge,alot]);
       if (nuts) for(x=[-raster:raster:raster]) translate([x,-tube/2-wall/2+wall_bridge,raster/2])rotate([90,90,0])hole();
       if (!nuts) for(x=[-raster:raster:raster]) translate([x,-tube/2-wall/2+wall_bridge,raster/2])rotate([90,90,0])cylinder(d=bolt_d,h=alot,center=true);
    }
  }
}

module double_clamp() {
  difference() {
    union() {
      translate([-rod_distance/2,0,0])clamp(tube=tube,wall_round=wall_round,wall=wall,part_thickness=part_thickness,tube_to_bolt=tube_to_bolt,bolt_d=bolt_d);
      translate([rod_distance/2,0,0])mirror([1,0,0]) clamp(tube=tube,wall_round=wall_round,wall=wall,part_thickness=part_thickness,tube_to_bolt=tube_to_bolt,bolt_d=bolt_d);
      bridge(wall_bridge=wall);
      rotate([180,0,0])bridge(wall_bridge=wall,nuts=false);
    }
  translate([-rod_distance/2,0,0])clamp(tube=tube,wall_round=wall_round,wall=wall,part_thickness=part_thickness,tube_to_bolt=tube_to_bolt,bolt_d=bolt_d,negative=true);
  translate([rod_distance/2,0,0])mirror([1,0,0])clamp(tube=tube,wall_round=wall_round,wall=wall,part_thickness=part_thickness,tube_to_bolt=tube_to_bolt,bolt_d=bolt_d,negative=true);  
  }
}
double_clamp();
