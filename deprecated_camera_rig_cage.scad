$fa=1/1;
$fs=1/2;
front=15;
back=18;
left=59;
right=63;
up=68;
bottom=8;
wall=6;
riser=3;
bissl=1/100;
d_hole=4;
d_nut=8;
h_nut=4;
raster=10;
tripod_screw_head=12;
tsh_height=5;
tripod_screw=7;
right_door=[-20,22,-5,52]; //format: [start_y,start_z,end_y,end_z], y is lens axis, 0 is at tripod thread
left_door=[0,0,0,0]; //format: [start_y,start_z,end_y,end_z], y is lens axis, 0 is at tripod thread
bottom_door=[11,-13,52,10];//format: [start_x,start_y,end_x,end_y], y is lens axis, 0 is at tripod thread
top_door=[16,-10,52,10];//format: [start_x,start_y,end_x,end_y], y is lens axis, 0 is at tripod thread
module camera() {
translate([-5.8,-19,25.5])rotate([0,0,-90])import("oly.stl",convexity=6);
}
*difference() {
  translate([-left-wall,-back,-bottom]) cube([left+right+2*wall,front+back,up+wall+bottom]);
  translate([-left,-back-bissl,riser]) cube([left+right,front+back+2*bissl,up-riser]);
  translate([-left-wall-bissl,left_door[0],left_door[1]])cube([wall+2*bissl,left_door[2]-left_door[0],left_door[3]-left_door[1]]);
  translate([right-bissl,right_door[0],right_door[1]])cube([wall+2*bissl,right_door[2]-right_door[0],right_door[3]-right_door[1]]);
  translate([bottom_door[0],bottom_door[1],-bottom-bissl])cube([bottom_door[2]-bottom_door[0],bottom_door[3]-bottom_door[1],bottom+riser+2*bissl]);
  translate([top_door[0],top_door[1],up-bissl])cube([top_door[2]-top_door[0],top_door[3]-top_door[1],wall+2*bissl]);
  camera();
  //bottom holes
  for (x=[-floor(left/raster-0.5)*raster:raster:right-raster/2])
    for (y=[-floor(back/raster-0.5)*raster:raster:front-raster/2]) 
      if (x<bottom_door[0]-raster/2 || x>bottom_door[2]+raster/2 || y<bottom_door[1]-raster/2 || y>bottom_door[3]+raster/2)
      translate([x,y,riser])rotate([180,0,0])nut_hole(d_hut=d_nut,d_hole=d_hole,depth=bottom+riser,h_nut=h_nut+riser);
  //top holes
  for (x=[-floor(left/raster-0.5)*raster:raster:right-raster/2])
    for (y=[-floor(back/raster-0.5)*raster:raster:front-raster/2]) 
    if (x<top_door[0]-raster/2 || x>top_door[2]+raster/2 || y<top_door[1]-raster/2 || y>top_door[3]+raster/2)
      translate([x,y,up])nut_hole(d_hut=d_nut,d_hole=d_hole,h_nut=h_nut,depth=wall);
  //left holes
  for (z=[raster/2:raster:up-raster/2])
    for (y=[-floor(back/raster-0.5)*raster:raster:front-raster/2]) 
      if (y<left_door[0]-raster/3 || y>left_door[2]+raster/3 || z<left_door[1]-raster/3 || z>left_door[3]+raster/3)
      translate([-left,y,z])rotate([0,-90,0])nut_hole(d_hut=d_nut,d_hole=d_hole,h_nut=h_nut,depth=wall);
  //right holes
  for (z=[raster/2:raster:up-raster/2])
    for (y=[-floor(back/raster-0.5)*raster:raster:front-raster/2]) 
      if (y<right_door[0]-raster/3 || y>right_door[2]+raster/3 || z<right_door[1]-raster/3 || z>right_door[3]+raster/3)
      translate([right,y,z])rotate([0,90,0])nut_hole(d_hut=d_nut,d_hole=d_hole,h_nut=h_nut,depth=wall);
   translate([0,0,-bottom-bissl])cylinder(d=tripod_screw,h=bottom+2*bissl);
   translate([0,0,-bottom-bissl])cylinder(d=tripod_screw_head,h=tsh_height);
*translate([0,0,-2])camerashape();
}
module nut_hole(d_hut=8,d_hole=4,h_nut=4,depth=10) {
  translate([0,0,-bissl]) cylinder(h=h_nut+bissl,d=d_nut,$fn=6);
  translate([0,0,-bissl]) cylinder(h=depth+2*bissl,d=d_hole); 
}

module camerashape() {
hull() {
  translate([-31,-11,0])bublik(3,6);
  translate([45,-11,0])bublik(3,6);
  translate([-29,7,0])bublik(3,10);
  translate([63,3,0])bublik(3,20);
  translate([66,-7,0])bublik(3,10);
  }
hull() {
translate([-15,7,0])bublik(3,10);
translate([15,7,0])bublik(3,10);
translate([0,11,0.5])bublik(3,10);
}
translate([0,10,31])rotate([-90,0,0])cylinder(h=10,d=62);
*translate([-50,-50,2])cube([200,100,100]);
module bublik(h,w) {
  minkowski() {
    translate([0,0,h/2])cylinder(d=w-h,h=bissl);
    sphere(r=h/2);
  }
  translate([0,0,h/2])cylinder(h=h/2,d=w);
}
}
*camera();
module corner(height,width, depth,code) {
  difference() {
    union() {
      if (code[0] && code[2]) translate([-left,-back,up-height])cube([width,depth,height]);
      if (code[1] && code[2]) translate([right-width,-back,up-height])cube([width,depth,height]);
      if (code[0] && code[3]) translate([-left,front-depth,up-height])cube([width,depth,height]);
      if (code[1] && code[3]) translate([right-width,front-depth,up-height])cube([width,depth,height]);
    }
  translate([-left+width/2,-back-bissl,up-height/2])rotate([-90,0,0])cylinder(d=d_hole,h=2*bissl+front+back);
  translate([right-width/2,-back-bissl,up-height/2])rotate([-90,0,0])cylinder(d=d_hole,h=2*bissl+front+back);
  camera();
  }
}
corner(13,10,15,[false,true,true,false]);
*camera();
