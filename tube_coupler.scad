$fs=1/1;
$fa=1/1;
cutview=false;
rounding_type="chamfer";//[fillet,chamfer,none]
rounding_amount=2;
meeting_angle=45;
tube=16;
wall=3;
screw=5;
tolerance=0.2;
dist=60;
module corner(type,r) {
  if (type=="none" || r==0) cube([0,0,0]);
  if (type=="fillet") sphere(r=r);
  if (type=="chamfer") for (i=[[0,0,0],[0,0,1]]) mirror(i) cylinder(r1=r,r2=0,h=r);
}
module gen_cyl(d=1,h=1,type="none",r=r,center=false) {
  if (type=="none") cylinder(d=d,h=h,center=center);
  else {
  if(center) minkowski() {cylinder(d=d-2*r,h=h-2*r,center=true); corner(type,r);}
  if(!center) minkowski() {translate([0,0,r])cylinder(d=d-2*r,h=h-2*r,center=false); corner(type,r);}
  }
}
module angle(d1=1,d2=1,o=1,a=90,type=none,r=1,wall=wall,tolerance=0) {
d=max([d1+2*wall+2*tolerance,d2+2*wall+2*tolerance,]);
pr=o/2+d1/4-d2/4;
maxang=max([abs(a*(1-pr/o)-90),abs(a*(1-pr/o)-90)]);
echo(maxang);
maxh=(type=="fillet")?(d-2*r)*sin(maxang)+(d-2*r)*cos(maxang)+2*r:
(type=="none")?d*sin(maxang)+d*cos(maxang):
max([(d-2*r)*sin(maxang)+(d)*cos(maxang),(d)*sin(maxang)+(d-2*r)*cos(maxang)]);
difference() {
hull(){
translate([o,0,0])gen_cyl(type=type,r=r,d=d,h=d,center=true);
rotate([a,0,0])gen_cyl(type=type,r=r,d=d,h=d,center=true);
rotate([a*(1-pr/o)-90,0,0])translate([pr,0,0])gen_cyl(type=type,r=(type=="fillet")?r:0,d=(type=="fillet")?2*screw+2*r:2*screw,h=maxh,center=true);
}
translate([o,0,0])cylinder(d=d2+2*tolerance,h=2*d,center=true);
rotate([a,0,0])cylinder(d=d1+2*tolerance,h=2*d,center=true);
rotate([0,90,0])linear_extrude(height=o,twist=a,convexity=2)rotate(a)square([2*d,wall],center=true);
rotate([90+a*(1-pr/o),0,0])translate([pr,0,0])cylinder(d=screw,h=2*d,center=true);
if(cutview)translate([pr,-50,-50])cube([100,100,100]);
}
}
angle(d1=tube,d2=tube,o=tube+2*wall,a=meeting_angle,type=rounding_type,r=rounding_amount,wall=wall,tolerance=tolerance);