use<polyround.scad>
use<cage.scad>
$fs=1/1;
$fa=1/1;
bissl=1/100;

chamfer=1; //edges rounding

//the shift of the inner wall plane in respective direction from the camera origin (tripod screw center)
/* [cage walls placement:] */
left=60;
top=67;
right=63;
bottom=-3;

//thickness of the respective wall
/* [walls' thickness:] */
wall_left=6;
wall_right=6;
wall_top=6;
wall_bottom=9;

/* [raster of holes:] */
min_hole_distance=4; //from center of the hole to the wall boundaries
bolt_d=4; //hole diameter
nut_d=8; //place for inserting hexagonal nuts, corner-to-corner
depth=2; //thickness of part of the wall, that holds the nut
raster=10; //distance between rows and columns of holes

/* [helping_tools:] */
markers=true;

x=0;//[-100:1:100]
y=0;//[-100:1:100]
z=0;//[-100:1:100]

//marker for finding right coordinates
if(markers && $preview)#translate([x,y,z])union(){
  cube([1,10,1],center=true);
  cube([10,1,1],center=true);
  cube([1,1,10],center=true);
}

function interpolator(a,b) = [for (i=[0:(norm(b-a)==0?2:1/norm(b-a)):1]) [a[0]+i*(b[0]-a[0]),a[1]+i*(b[1]-a[1])]]; //avoid division by zero
function polyinterpolator(p) = [for (i=[0:len(p)-1]) each interpolator(p[i],p[i<len(p)-1?i+1:0])];
function distance(point,polygon)= len(polygon)>0?min([for (p=polyinterpolator(polygon)) norm(p-point)]):10000;

module camera() {
difference(){
translate([-5.8,-19,25.5])rotate([0,0,-90])import("cameras/Olympus_E-PM1.stl",convexity=6);
translate([-100,-100,-10])cube([200,200,10]);}
}
/*
module hole(wall,depth) {
  translate([0,0,-bissl]) cylinder(d=bolt_d,h=wall+2*bissl);
  translate([0,0,-bissl]) cylinder(d=nut_d,h=wall-depth+bissl,$fn=6);
}

shape_left=[
  [13,-bottom,chamfer],
  [13,top,chamfer],
  [-18,top,chamfer],
  [-18,-bottom,chamfer]
];
cutouts_left=[
];
shape_right=[
  [13,-bottom,chamfer],
  [13,top,chamfer],
  [-12,top,chamfer],
  [-12,56,5],
  [-4,48,5],
  [-4,26,5],
  [-18,12,5],
  [-18,-bottom,chamfer],
];
cutouts_right=[
];
shape_top=[
  [-left,-18,chamfer],
  [-left,13,chamfer],
  [right,13,chamfer],
  [right,-12,chamfer],
  [30,-12,5],
  [25,-18,5],
];
cutouts_top=[
];
shape_bottom=[
  [-left,-18,chamfer],
  [-left,13,chamfer],
  [right,13,chamfer],
  [right,-18,chamfer]
];
cutouts_bottom=[
for(a=[0:12:360]) [sin(a)*4,cos(a)*4,0]
];

module cage_wall(shape,cutouts,wall,chamfer) {
  intersection() {
    linear_extrude(height=wall,convexity=2) if (len(shape)>0) polygon( polyRound(shape) );
    union() {
      linear_extrude(height=wall-chamfer) difference() {
        if (len(shape)>0) polygon( polyRound(shape) );
        if (len(cutouts)>0) polygon( polyRound(cutouts) );
      }
      translate([0,0,wall-chamfer])roof()difference() {
        if (len(shape)>0) polygon( polyRound(shape) );
        if (len(cutouts)>0) polygon( polyRound(cutouts) );
      }
    }
  }
  if(markers && $preview)#for (i=[0:len(shape)-1]) translate([shape[i][0],shape[i][1],wall]) {
    sphere(1);
    linear_extrude(bissl)text(text=str(i,": (", shape[i][0],", ",shape[i][1],")"),size=4);
    }
}

module wall_holes(shape,cutouts,wall,raster,mindist,start) {
  minx=min([for (xy=shape) xy[0], for (xy=cutouts) xy[0]]);
  maxx=max([for (xy=shape) xy[0], for (xy=shape) xy[0]]);
  miny=min([for (xy=shape) xy[1], for (xy=shape) xy[1]]);
  maxy=max([for (xy=shape) xy[1], for (xy=shape) xy[1]]);
  for(x=[minx+start[0]:raster:maxx]) 
    for(y=[miny+start[1]:raster:maxy])
      if (distance([x,y],len(shape)>0?polyRound(shape):[])>=mindist && distance([x,y],len(cutouts)>0?polyRound(cutouts):[])>=mindist)
        //translate([x,y,-bissl])cylinder(d=bolt_d,h=wall+2*bissl);
        translate([x,y,0])hole(wall,depth);
}

module cage() {
  translate([-left,0,0])mirror([1,0,0])rotate([90,0,90])difference() {
    cage_wall(shape_left,cutouts_left,wall_left,chamfer);
    wall_holes(shape_left,cutouts_left,wall_left,raster,min_hole_distance,[0,0]);
  }
  translate([right,0,0])mirror([0,0,0])rotate([90,0,90])difference() {
    cage_wall(shape_right,cutouts_right,wall_right,chamfer);
    wall_holes(shape_right,cutouts_right,wall_right,raster,min_hole_distance,[0,0]);
  }
  translate([0,0,top])mirror([0,0,0])rotate([0,0,0])difference() {
    cage_wall(shape_top,cutouts_top,wall_top,chamfer);
    wall_holes(shape_top,cutouts_top,wall_top,raster,min_hole_distance,[0,5.5]);
  }
  difference() {
    translate([0,0,-bottom])mirror([0,0,1])rotate([0,0,0]) cage_wall(shape_bottom,cutouts_bottom,wall_bottom,chamfer);
    translate([0,0,-bottom])mirror([0,0,1])rotate([0,0,0]) wall_holes(shape_bottom,cutouts_bottom,wall_bottom,raster,min_hole_distance,[0,5.5]);
    camera();
  }
  connectors();
}

module connectors() { //those corner parts that connect 4 sides of the cage together

  module four_walls() { //simplified version of the cage with no holes, just to calculate the geometry of corner connecting bits
    translate([-left,0,0])mirror([1,0,0])rotate([90,0,90]) cage_wall(shape_left,cutouts_left,wall_left,chamfer);
    translate([right,0,0])mirror([0,0,0])rotate([90,0,90])cage_wall(shape_right,cutouts_right,wall_right,chamfer);
    translate([0,0,top])mirror([0,0,0])rotate([0,0,0]) cage_wall(shape_top,cutouts_top,wall_top,chamfer);
    translate([0,0,-bottom])mirror([0,0,1])rotate([0,0,0])cage_wall(shape_bottom,cutouts_bottom,wall_bottom,chamfer);
  }
/* I've written that a little more elegant now
  module corner(x,z,maxwall,orientation,maxdepth=100) { //bounding box of the corner connecting area
    translate([x,-maxdepth/2,z])rotate([0,orientation,0])translate([-chamfer,0,-chamfer])cube([maxwall,maxdepth,maxwall]);
  }

  for (param=[
    [right,top,max(wall_right,wall_top),0],
    [right,-bottom,max(wall_right,wall_bottom),90],
    [-left,top,max(wall_left,wall_top),-90],
    [-left,-bottom,max(wall_left,wall_bottom),180]
  ]) hull() intersection() {
    #corner(param[0],param[1],param[2],param[3]);
    four_walls();
  }
 
  for (lr=[[-left-wall_left+chamfer,-left+chamfer],[right-chamfer,right+wall_right-chamfer]])
    for (bt=[[-bottom-wall_bottom+chamfer,-bottom+chamfer],[top-chamfer,top+wall_top-chamfer]])
      hull() intersection() {
        translate([lr[0],-100,bt[0]])cube([lr[1]-lr[0],200,bt[1]-bt[0]]);
        four_walls();
      }
}

//uncomment the following module if you don't have the experimental roof() feature turned on in Openscad. 
//This implementation is slower but would work on older releases of OpenSCAD
/*
module roof() {
  maxdist=max(wall_left,wall_right,wall_top,wall_bottom);
  difference(){
    linear_extrude(height=maxdist,convexity=3) children();
    minkowski(convexity=3) {
      cylinder(d1=0,d2=maxdist*2,h=maxdist);
      linear_extrude(1/100,convexity=3)difference() {
        offset(r=1/100)children();
        children();
      }
    }
  }
}
*/ 
if(markers && $preview)camera();
if(markers && $preview)%cage();
else cage() camera();

