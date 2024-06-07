use<include/spline.scad>
fr=[[0,-55],[15,-54],[26,-52],[38,-49],[48,-45],[60,-37],[73,-27],[86,-18],[101,-6],[107,9]];
ba=[[0,11],[15,9],[25,21],[38,19],[48,30],[60,28],[73,38],[86,36],[101,47],[107,47]];
function decimate(poly,m)=len(poly)<3?poly
                         :norm(poly[0]-poly[1])<m?decimate([poly[0], for (i=[2:len(poly)-1]) poly[i]],m)
                         :[poly[0], each decimate([for (i=[1:len(poly)-1]) poly[i]],m)];
$fn=64;
module skew_extrude(list,d,reverse) {
  for (i=[0:len(list)-2]) {
    startx=list[i][0];
    startz=list[i][1]+d*(reverse?-1:1)/2;
    h=list[i+1][0]-list[i][0];
    shift=list[i+1][1]-list[i][1];
    multmatrix(m=[[d,0,shift,startz],
                  [0,d,0,0],
                  [0,0,h,startx]]){cylinder(d=1,h=1);translate([reverse?-10:0,-0.5,0])cube([10,1,1]);}
  }
}
difference(){
intersection(){
skew_extrude(list=decimate(smooth(fr,6),1),d=30,reverse=false);
skew_extrude(list=decimate(smooth(ba,6),1),d=30,reverse=true);
}
hull() for (tr=[[-31,0,10],[2,0,80]]) translate(tr)
rotate([90,0,0])cylinder(d=5,h=31,center=true);
hull() for (tr=[[-31,-1.6,10],[2,-1.6,80]]) translate(tr)
rotate([90,0,0])cylinder(d=12,h=31);
hull() for (tr=[[-31,1.6,10],[2,1.6,80]]) translate(tr)
rotate([-90,0,0])cylinder(d=12,h=31);}