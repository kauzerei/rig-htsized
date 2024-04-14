$fa=1/1;
$fs=1/1;
$fn=16;
radius=1;
step=1;
border=6;
height=5;
air=1;
chamfer=true;
module cs() {
  render() projection(cut=true) translate([0,0,-border]) camera();
}

module camera() {
translate([-1,-12,0])import("eos_10_lr.stl");
}

module battery_door(rotated=0) {
  translate([12,-67,3])rotate([0,0,135])rotate([0,-rotated,0]) hull(){
  translate([-12,-8.7,-1])cylinder(d=19,h=4,center=true);
  translate([-12,8.7,-1])cylinder(d=19,h=4,center=true);
}
}
module battery_protrusion() {
  translate([12,-67,0]) rotate([0,0,135]) {
    translate([-12,-8.7,0]) cylinder(d=16,h=40);
    translate([-12,8.7,0]) cylinder(d=16,h=40);
    translate([-18,-9,0]) cube([14,18,40]);
  }
}

module space_for_door(angle=45,travel=30,precision=10) {
  minkowski($fn=16) {
  battery_door(angle);
  translate([0,0,-air])cylinder(h=travel,r=air);
  }
}

module space_for_battery() {
  translate([-40,-5,-20])cube([70,20,21]);
}

module complete_grip() {
  difference() {
    union() {
      battery_protrusion();
      grip_body();
    }
    space_for_door();
*    space_for_battery();
#    translate([0,0,-height])cylinder(d=25.4/4,h=2*height);
  }
}

module grip_body() {
  difference() {
    minkowski() {
      translate([0,0,-height+radius]) render()
        linear_extrude(height=height-radius+border-air,convexity=4) offset(r=-radius)cs();
      intersection() {
        if(chamfer) translate([0,0,-radius]) cylinder (r1=0,r2=radius+air,h=radius);
        else {sphere(r=radius,$fn=16);
        translate([-radius,-radius,-radius])cube([2*radius,2*radius,radius]);
        }
      }
    }
    camera();
  }
}
complete_grip();
*camera();
*battery_door();
*battery_protrusion();