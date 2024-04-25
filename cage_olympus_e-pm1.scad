// Instance of cage() for Olympus PEN E-PM1
use<cage.scad>
use<polyround.scad>
$fs = 1 / 1;
$fa = 1 / 1;
bissl = 1 / 100;

chamfer = 1; // edges rounding

// the shift of the inner wall plane in respective direction from the camera
// origin (tripod screw center)
/* [cage walls placement:] */
left = 60;
top = 67;
right = 63;
bottom = -3;

// thickness of the respective wall
/* [walls' thickness:] */
wall_left = 6;
wall_right = 6;
wall_top = 6;
wall_bottom = 9;

/* [raster of holes:] */
min_hole_distance = 4; // from center of the hole to the wall boundaries
bolt_d = 4;            // hole diameter
nut_d = 8;             // place for inserting hexagonal nuts, corner-to-corner
depth = 2;             // thickness of part of the wall, that holds the nut
raster = 10;           // distance between rows and columns of holes

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

shape_left = [
  [ 13, -bottom, chamfer ],
  [ 13, top, chamfer ], 
  [ -18, top, chamfer ],
  [ -18, -bottom, chamfer ]
];
cutout_left = [];
placement_left = [
  [ -left, 0, 0 ], [ 1, 0, 0 ], [ 90, 0, 90 ]
]; // translate(), mirror(), and rotate() arguments for wall
raster_shift_left = [ 5.5, -3 ];

shape_right = [
  [ 13, -bottom, chamfer ],
  [ 13, top, chamfer ],
  [ -12, top, chamfer ],
  [ -12, 56, 5 ],
  [ -4, 48, 5 ],
  [ -4, 26, 5 ],
  [ -18, 12, 5 ],
  [ -18, -bottom, chamfer ],
];
cutout_right = [];
placement_right = [[right, 0, 0], [0, 0, 0], [90, 0, 90]];
raster_shift_right = [ 5.5, -3 ];

shape_top = [
  [ -left, -18, chamfer ],
  [ -left, 13, chamfer ],
  [ 20, 13, 5 ],
  [ 24, 20, 5 ],
  [ right, 20, chamfer ],
  [ right, -12, chamfer ],
  [ 30, -12, 5 ],
  [ 25, -18, 5 ],
];
cutout_top = [ 
  [ 26, -6, 2 ],
  [ 55, -6, 2 ],
  [ 55, 14, 2 ],
  [ 26, 14, 2 ] ];
placement_top = [ [ 0, 0, top ], [ 0, 0, 0 ], [ 0, 0, 0 ] ];
raster_shift_top = [ 0, 5.5 ];

shape_bottom = [
  [ -left, -18, chamfer ],
  [ -left, 13, chamfer ],
  [ right, 13, chamfer ],
  [ right, -18, chamfer ]
];
cutout_bottom = [for (a = [0:12:360])[sin(a) * 4, cos(a) * 4, 0]];
placement_bottom = [ [ 0, 0, -bottom ], [ 0, 0, 1 ], [ 0, 0, 0 ] ];
raster_shift_bottom = [ 0, 5.5 ];

module camera() {
  scale([ 1.01, 1.01, 1.01 ]) translate([ -5.8, -19, 25.5 ])
      rotate([ 0, 0, -90 ]) import("cameras/Olympus_E-PM1.stl", convexity = 6);
}

if (markers && $preview)
  camera();
if (markers && $preview)
  % difference() {
    cage(shapes = [ shape_left, shape_top, shape_right, shape_bottom ],
         cutouts = [ cutout_left, cutout_top, cutout_right, cutout_bottom ],
         placements = [ placement_left, placement_top, placement_right, placement_bottom ],
         walls = [ wall_left, wall_top, wall_right, wall_bottom ],
         raster_shifts = [ raster_shift_left, raster_shift_top, raster_shift_right, raster_shift_bottom ],
         chamfer, raster, min_hole_distance, false, markers);
    camera();
  }
else
  difference() {
    cage(shapes = [ shape_left, shape_top, shape_right, shape_bottom ],
         cutouts = [ cutout_left, cutout_top, cutout_right, cutout_bottom ],
         placements = [ placement_left, placement_top, placement_right, placement_bottom ],
         walls = [ wall_left, wall_top, wall_right, wall_bottom ],
         raster_shifts = [ raster_shift_left, raster_shift_top, raster_shift_right, raster_shift_bottom ],
         chamfer, raster, min_hole_distance, false, markers);
    camera();
  }