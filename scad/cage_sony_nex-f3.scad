// Instance of cage() for Sony NEX-F3
use<cage.scad>
$fs = 1 / 1;
$fa = 1 / 1;
bissl = 1 / 100;

part = "frame";//[frame, corner_fl, corner_fr, corner_rl, corner_rr]
chamfer = 1; // edges rounding

// the shift of the inner wall plane in respective direction from the camera
// origin (tripod screw center)
/* [cage walls placement:] */
left = 42;
top = 66;
right = 79;
bottom = -3;

// thickness of the respective wall
/* [walls' thickness:] */
wall_left = 6;
wall_right = 6;
wall_top = 6;
wall_bottom = 13;

/* [raster of holes:] */
min_hole_distance = 4; // from center of the hole to the wall boundaries
bolt_d = 4;            // hole diameter
nut_d = 8;             // place for inserting hexagonal nuts, corner-to-corner
depth = 2;             // thickness of part of the wall, that holds the nut
raster = 10;           // distance between rows and columns of holes

tripod_thread_d = 7; //tripod screw
tripod_head_d=12;
tripod_head_h=4;

/* [helping_tools:] */
markers = false;

x = 0; //[-100:1:100]
y = 0; //[-100:1:100]
z = 0; //[-100:1:100]

// marker for finding right coordinates
if (markers && $preview)
#translate([ x, y, z ]) union() {
    cube([ 1, 10, 1 ], center = true);
    cube([ 10, 1, 1 ], center = true);
    cube([ 1, 1, 10 ], center = true);
  }

module camera() {
  difference() {
    scale([ 1.01, 1.01, 1.01 ]) translate([ 17.5, -13.8, 25.2 ])
        rotate([ 0, 0, 90 ]) import("../cameras/Sony_NEX-F3.stl", convexity = 6);
    translate([ -100, -100, -10 ]) cube([ 200, 200, 10 ]);
  }
}

shape_left = [
  [ 30, -bottom, chamfer ],
  [ 30, top, chamfer ],
  [ -13, top, chamfer ],
  [ -13, 55, 5 ],
  [ 10, 55, 5 ],
  [ 10, -bottom, chamfer ]
];
cutout_left = [[]];
placement_left = [
  [ -left, 0, 0 ], [ 1, 0, 0 ], [ 90, 0, 90 ]
];
raster_shift_left = [ 8, -3 ];

shape_right = [
  [ 13, -bottom, chamfer ],
  [ 13, top, chamfer ],
  [ -13, top, chamfer ],
  [ -13, 55, 5 ],
  [ -13, 52, 5 ],
  [ -13, -bottom, chamfer ],
];
cutout_right = [[]];
placement_right = [[right, 0, 0], [0, 0, 0], [90, 0, 90]];
raster_shift_right = [ 8, -3 ];

shape_top = [
  [ -left, -13, chamfer ],
  [ -left, 30, chamfer ],
  [ -28, 30, 10 ],
  [ -20, 20, 10 ],
  [ 18, 20, 10 ],
  [ 30, -1, 10 ],
  [ 64, -1, 10 ],
  [ 74, 13, 5 ],
  [ right, 13, chamfer ],
  [ right, -13, chamfer ],
  [ 55, -13, 10 ],
];
cutout_top = [[]];
placement_top = [ [ 0, 0, top ], [ 0, 0, 0 ], [ 0, 0, 0 ] ];
raster_shift_top = [ 2, 6 ];

shape_bottom = [
  [ -left, -13, 10 ],
  [ -left, 30, chamfer ], 
  [ -37, 30, 10 ], 
  [ -30, 18, 10 ],
  [ 33, 18, 10 ],
  [ 40, 13, 10 ],
  [ right, 13, chamfer ],
  [ right, -13, chamfer ]
];
cutout_bottom = [[for (a = [0:12:360])[sin(a) * tripod_thread_d/2, cos(a) * tripod_thread_d/2, 0]],[[50,-4,chamfer],[50,6,chamfer],[75,6,chamfer],[75,-4,chamfer]]]; //tripod mount
placement_bottom = [ [ 0, 0, -bottom ], [ 0, 0, 1 ], [ 0, 0, 0 ] ];
raster_shift_bottom = [ 2, 6 ];

//This is ugly as hell, I know
//I'll change it when I test the parts properly and then find an elegant way of rewriting
//Now it just works for this particular camera
module corner(i){
  difference() {
    if (i == "corner_fl") difference() {
      translate([-left, 7, top - 10]) cube([10, 10, 10]);
      translate([-left + 4, 7, top - 5]) rotate([-90, 0, 0]) cylinder(d = bolt_d, h = 10);
    }
    if (i == "corner_rl") difference() {
      translate([-left, -10, top - 10]) cube([10, 10, 10]);
      translate([-left + 4, -10, top - 5]) rotate([-90, 0, 0]) {
        translate([0, 0, 4.4]) cylinder(d = bolt_d, h = 10);
        cylinder(d = nut_d, h = 4, $fn = 6);
      }
    }
    if (i == "corner_rr") difference() {
      translate([right - 10, -13, top - 10]) cube([10, 10, 10]);
      translate([right - 4, -13, top - 4]) rotate([-90, 0, 0]) {
        translate([0, 0, 4.4]) cylinder(d = bolt_d, h = 10);
        cylinder(d = nut_d, h = 4, $fn = 6);
      }
    }
    if (i == "corner_fr") difference() {
      translate([right - 10, 3, top - 10]) cube([10, 10, 10]);
      translate([right - 4, 3, top - 4]) rotate([-90, 0, 0]) cylinder(d = bolt_d, h = 10);
    }
  }
}

if (part == "frame" ) { //generating the cage itself
  if (markers && $preview) camera();
  if (markers && $preview) //if generated for visualization
    % difference() {
      cage(shapes = [ shape_left, shape_top, shape_right, shape_bottom ],
           cutouts = [ cutout_left, cutout_top, cutout_right, cutout_bottom ],
           placements = [ placement_left, placement_top, placement_right, placement_bottom ],
           walls = [ wall_left, wall_top, wall_right, wall_bottom ],
           raster_shifts = [ raster_shift_left, raster_shift_top, raster_shift_right, raster_shift_bottom ],
           chamfer, raster, min_hole_distance, false, markers);
      camera();
}
else //if no markers, e.g. generating real part
  difference() {
    cage(shapes = [ shape_left, shape_top, shape_right, shape_bottom ],
         cutouts = [ cutout_left, cutout_top, cutout_right, cutout_bottom ],
         placements = [ placement_left, placement_top, placement_right, placement_bottom ],
         walls = [ wall_left, wall_top, wall_right, wall_bottom ],
         raster_shifts = [ raster_shift_left, raster_shift_top, raster_shift_right, raster_shift_bottom ],
         chamfer, raster, min_hole_distance, false, markers);
    camera();
    translate([0,0,-bottom-wall_bottom-1/100])cylinder(d=tripod_head_d,h=tripod_head_h);
  }
}
else difference() { //If not the cage itself
  corner(part);
  camera();
  cage(shapes = [ shape_left, shape_top, shape_right, shape_bottom ],
       cutouts = [ cutout_left, cutout_top, cutout_right, cutout_bottom ],
       placements = [ placement_left, placement_top, placement_right, placement_bottom ],
       walls = [ wall_left, wall_top, wall_right, wall_bottom ],
       raster_shifts = [ raster_shift_left, raster_shift_top, raster_shift_right, raster_shift_bottom ],
       chamfer, raster, min_hole_distance, false, markers);
}