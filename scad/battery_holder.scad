battery_d=19;
battery_l=65;
spring_depth=5;
spring_thickness=1.3;
spring_width=7;
spring_height=14.5;
wall=1.6;
bottom=1.6;
channel=2;
arc_depth=0.75*battery_d;
arc_width=0.8*battery_l;
arc_r=(arc_width^2+4*arc_depth^2)/arc_depth/8;
bsl=1/100;
$fa=1/2;
$fs=1/2;

module spring_cutout(sd,st,sw,sh,bd,w) {
  cutout=(bd-sh)/2;
  translate([0,-sw/2,cutout])cube([st,sw,bd-cutout+bsl]);
  translate([0,-sw/2,bd-cutout])cube([st+wall+bsl,sw,cutout+bsl]);
  translate([0,-sw/2+w,0])cube([st+wall+bsl,sw-2*w,bd+bsl]);
}

module single_cell(bd,bl,sd,st,sw,sh,w,b) {
  difference() {
    cube([bl+2*sd+2*w,bd+2*w,bd+b]);
    translate([w+st+w,w,b]) cube([bl+2*sd-2*st-2*w,bd,bd+bsl]);
    translate([w,w+bd/2,b])spring_cutout(sd=sd,st=st,sw=sw,sh=sh,bd=bd,w=w);
    translate([bl+2*sd+w,w+bd/2,b])rotate([0,0,180])spring_cutout(sd=sd,st=st,sw=sw,sh=sh,bd=bd,w=w);
    translate([bl/2+sd+w,-bsl,bd+b+arc_r-arc_depth])rotate([-90,0,0])cylinder(r=arc_r,h=bd+2*w+2*bsl);
  }
}

module screw_mount(square,circle,height) {

}

module double_battery_holder(bd,bl,sd,st,sw,sh,w,b,c) {
  difference() {
    union() {
      single_cell(bd=bd,bl=bl,sd=sd,st=st,sw=sw,sh=sh,w=w,b=b);
      translate([0,bd+w,0])single_cell(bd=bd,bl=bl,sd=sd,st=st,sw=sw,sh=sh,w=w,b=b);
    }
    for (tr=[[w+st+w+c/2,w/2,w+c/2],
              [w+st+w+c/2,w/2,w+c/2+w+c],
              [w+st+w+c/2,w/2+bd+w,w+c/2],
              [w+st+w+c/2+bl+2*sd-2*st-2*w-c,w/2+bd+w,w+c/2],
             ]) translate(tr) rotate([-90,0,0])cylinder(d=c,h=w+bsl,center=true);
  }
}


//single_cell(bd=battery_d,bl=battery_l,sd=spring_depth,st=spring_thickness,sw=spring_width,sh=spring_height,w=wall,b=bottom);
//spring_cutout(sd=spring_depth,st=spring_thickness,sw=spring_width,sh=spring_height,bd=battery_d,w=wall);
double_battery_holder(bd=battery_d,bl=battery_l,sd=spring_depth,st=spring_thickness,sw=spring_width,sh=spring_height,w=wall,b=bottom,c=channel);
