use<polyround.scad>
$fs=1/1;
$fa=1/1;
bissl=1/100;
left=60;
top=67;
right=63;
bottom=-3;
wall_left=6;
wall_right=6;
wall_top=6;
wall_bottom=9;
minwall=4;
chamfer=1;

bolt_d=4;
raster=10;

helper=true;

x=0;//[-100:1:100]
y=0;//[-100:1:100]
z=0;//[-100:1:100]
if(helper)#translate([x,y,z])sphere(r=1,$fn=8);

function interpolator(a,b) = [for (i=[0:(norm(b-a)==0?2:1/norm(b-a)):1]) [a[0]+i*(b[0]-a[0]),a[1]+i*(b[1]-a[1])]];
function polyinterpolator(p) = [for (i=[0:len(p)-1]) each interpolator(p[i],p[i<len(p)-1?i+1:0])];
function distance(point,polygon)= min([for (p=polyinterpolator(polygon)) norm(p-point)]);

module camera() {
translate([-3,-18,27])rotate([1,180,-90])import("oly.stl",convexity=6);
}

shape_left=[
  [13,0,chamfer],
  [13,67,chamfer],
  [-18,67,chamfer],
  [-18,0,chamfer]
];
cutouts_left=[
  [0,0,0],
  [0,0,0],
  [0,0,0],
  [0,0,0],
];
shape_right=[
  [13,0,chamfer],
  [13,67,chamfer],
  [-12,67,chamfer],
  [-12,56,5],
  [-4,48,5],
  [-4,26,5],
  [-18,12,5],
  [-18,0,chamfer],
];
cutouts_right=[
  [0,0,0],
  [0,0,0],
  [0,0,0],
  [0,0,0],
];
shape_top=[
  [-60,-18,chamfer],
  [-60,13,chamfer],
  [63,13,chamfer],
  [63,-12,chamfer],
  [30,-12,5],
  [25,-18,5],
];
cutouts_top=[
  [0,0,0],
];
shape_bottom=[
  [-60,-18,0,chamfer],
  [-60,13,chamfer],
  [63,13,chamfer],
  [63,-18,chamfer]
];
cutouts_bottom=[
  [0,0,0],
  [0,0,0],
  [0,0,0],
  [0,0,0],
];

module cage_wall(shape,cutouts,wall,chamfer) {
  intersection() {
    linear_extrude(height=wall,convexity=6) polygon( polyRound(shape) );
    union() {
      translate([0,0,0])linear_extrude(height=wall-chamfer) difference() {
        polygon( polyRound(shape) );
        polygon( polyRound(cutouts) );
      }
      translate([0,0,wall-chamfer])roof(method="straight")difference() {
        polygon( polyRound(shape) );
        polygon( polyRound(cutouts) );
      }
    }
  }
  if(helper)#for (i=[0:len(shape)-1]) translate([shape[i][0],shape[i][1],wall]) {
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
      if (distance([x,y],polyRound(shape))>=mindist && distance([x,y],polyRound(cutouts))>=mindist)
        translate([x,y,-bissl])cylinder(d=bolt_d,h=wall+2*bissl);
}

module four_walls() {
translate([-left,0,0])mirror([1,0,0])rotate([90,0,90]) cage_wall(shape_left,cutouts_left,wall_left,chamfer);
translate([right,0,0])mirror([0,0,0])rotate([90,0,90])cage_wall(shape_right,cutouts_right,wall_right,chamfer);
translate([0,0,top])mirror([0,0,0])rotate([0,0,0]) cage_wall(shape_top,cutouts_top,wall_top,chamfer);
translate([0,0,-bottom])mirror([0,0,1])rotate([0,0,0])cage_wall(shape_bottom,cutouts_bottom,wall_bottom,chamfer);
}

module cage() {
  translate([-left,0,0])mirror([1,0,0])rotate([90,0,90])difference() {
    cage_wall(shape_left,cutouts_left,wall_left,chamfer);
    wall_holes(shape_left,cutouts_left,wall_left,raster,minwall,[minwall,6]);
  }
  translate([right,0,0])mirror([0,0,0])rotate([90,0,90])difference() {
    cage_wall(shape_right,cutouts_right,wall_right,chamfer);
    wall_holes(shape_right,cutouts_right,wall_right,raster,minwall,[minwall,minwall]);
  }
  translate([0,0,top])mirror([0,0,0])rotate([0,0,0])difference() {
    cage_wall(shape_top,cutouts_top,wall_top,chamfer);
    wall_holes(shape_top,cutouts_top,wall_top,raster,minwall,[minwall,minwall]);
  }
  difference() {
    translate([0,0,-bottom])mirror([0,0,1])rotate([0,0,0]) cage_wall(shape_bottom,cutouts_bottom,wall_bottom,chamfer);
    translate([0,0,-bottom])mirror([0,0,1])rotate([0,0,0]) wall_holes(shape_bottom,cutouts_bottom,wall_bottom,raster,minwall,[-left,-1]);
    camera();
  }
  connectors();
}


module corner(x,z,maxwall,orientation,maxdepth=100) {
  translate([x,-maxdepth/2,z])rotate([0,orientation,0])translate([-chamfer,0,-chamfer])cube([maxwall,maxdepth,maxwall]);
}

module connectors() {
  for (param=[
    [right,top,max(wall_right,wall_top),0],
    [right,-bottom,max(wall_right,wall_bottom),90],
    [-left,top,max(wall_left,wall_top),-90],
    [-left,-bottom,max(wall_left,wall_bottom),180]
  ]) hull() intersection() {
    corner(param[0],param[1],param[2],param[3]);
    four_walls();
  }
}
//
*camera();
cage();
