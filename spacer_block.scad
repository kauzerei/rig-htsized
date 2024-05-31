$fs=1/2;
width=48;
height=30;
depth=30;
hole=4.5;
raster=10;
startx=-(width/2-hole)+(width/2-hole)%raster;
starty=-(depth/2-hole)+(depth/2-hole)%raster;
difference() {
  cube([width,depth,height],center=true);
  for (x=[startx:raster:width/2-hole]) for (y=[starty:raster:depth/2-hole]) translate([x,y,0])cylinder(h=height+1,d=hole,center=true);
}