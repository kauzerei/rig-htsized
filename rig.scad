$fn=64;
tube=16;
wall=3;
gap=3;
tolerance=0.2;
dist=60;
r=3;
module corner(type,r) {
  if (type=="none" || r==0) cube([0,0,0]);
  if (type=="chamfer") sphere(r=r);
  if (type=="fillet") for (i=[[0,0,0],[0,0,1]]) mirror(i) cylinder(r1=r,r2=0,h=r);
}
module gen_cyl(d=1,h=1,type="none",r=r,center=false) {
  if(center) minkowski() {cylinder(d=d-2*r,h=h-2*r,center=true); corner(type,r);}
  if(!center) minkowski() {translate([0,0,r])cylinder(d=d-2*r,h=h-2*r,center=false); corner(type,r);}
}
hull(){
translate([tube+2*wall,0,0])gen_cyl(type="chamfer",r=r,d=tube+2*wall,h=tube+2*wall,center=true);
rotate([90,0,0])gen_cyl(type="chamfer",r=r,d=tube+2*wall,h=tube+2*wall,center=true);
}