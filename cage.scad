// Set of modules that help generating camera-specific cages.
// Use the beginning of this file (up to function declarations) as a template
// and cage_*.scad instances as reference.

use<include/polyround.scad>
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
hole_d = 4.5;            // hole diameter
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

module camera() {}

module hole(wall, depth) {
  translate([ 0, 0, -bissl ]) cylinder(d = hole_d, h = wall + 2 * bissl);
  translate([ 0, 0, -bissl ])
      cylinder(d = nut_d, h = wall - depth + bissl, $fn = 6);
}

shape_left = [
  [ 20, -bottom, chamfer ],
  [ 20, top, chamfer ],
  [ -20, top, chamfer ],
  [ -20, -bottom, chamfer ]
];
cutout_left = [[]];
placement_left = [
  [ -left, 0, 0 ], [ 1, 0, 0 ], [ 90, 0, 90 ]
]; // translate(), mirror(), and rotate() arguments for wall
raster_shift_left = [ 0, 0 ];

shape_right = [
  [ 20, -bottom, chamfer ],
  [ 20, top, chamfer ],
  [ -20, top, chamfer ],
  [ -20, -bottom, chamfer ],
];
cutout_right = [[]];
placement_right = [[right, 0, 0], [0, 0, 0], [90, 0, 90]];
raster_shift_right = [ 0, 0 ];

shape_top = [
  [ -left, -20, chamfer ],
  [ -left, 20, chamfer ],
  [ right, 20, chamfer ],
  [ right, -20, chamfer ],
];
cutout_top = [[]];
placement_top = [ [ 0, 0, top ], [ 0, 0, 0 ], [ 0, 0, 0 ] ];
raster_shift_top = [ 0, 0 ];

shape_bottom = [
  [ -left, -20, chamfer ],
  [ -left, 20, chamfer ],
  [ right, 20, chamfer ],
  [ right, -20, chamfer ]
];
//cutout_bottom = [[for (a = [0:12:360])[sin(a) * 4, cos(a) * 4, 0]]];
cutout_bottom = [[]];
placement_bottom = [ [ 0, 0, -bottom ], [ 0, 0, 1 ], [ 0, 0, 0 ] ];
raster_shift_bottom = [ 0, 0 ];

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

// Template ends here

function interpolator(a, b) =
    [for (i = [0:(norm(b - a) == 0 ? 2 : 1 / norm(b - a)
                  ):1])[a[0] + i * (b[0] - a[0]),
                        a[1] + i *(b[1] - a[1])]]; // avoid division by zero
function polyinterpolator(p) = [for (i = [0:len(p) - 1])
        each interpolator(p[i], p[i < len(p) - 1 ? i + 1 : 0])];
function distance(point,
                  polygon) = len(polygon) > 0
                                 ? min([for (p = polyinterpolator(polygon))
                                           norm(p - point)])
                                 : 10000;

module cage_wall(shape, cutouts, wall, chamfer, markers) {
  intersection() {
    linear_extrude(height = wall, convexity = 2) if (len(shape) > 0)
        polygon(polyRound(shape));
    union() {
      linear_extrude(height = wall - chamfer) difference() {
        if (len(shape) > 0)
          polygon(polyRound(shape));
        for (cutout=cutouts) if (len(cutout) > 0)
          polygon(polyRound(cutout));
      }
      translate([ 0, 0, wall - chamfer ]) roof() difference() {
        if (len(shape) > 0)
          polygon(polyRound(shape));
        for (cutout=cutouts)if (len(cutout) > 0)
          polygon(polyRound(cutout));
      }
    }
  }
  if (markers && $preview)
#for (i = [0:len(shape) - 1])
        translate([ shape[i][0], shape[i][1], wall ]) {
      sphere(1);
      linear_extrude(bissl) text(
          text = str(i, ": (", shape[i][0], ", ", shape[i][1], ")"), size = 4);
    }
}

module wall_holes(shape, cutouts, wall, raster, mindist, start) {
  minx = min([ for (xy = shape) xy[0], for (cutout=cutouts) for (xy=cutout) xy[0] ]);
  maxx = max([ for (xy = shape) xy[0], for (xy = shape) xy[0] ]);
  miny = min([ for (xy = shape) xy[1], for (xy = shape) xy[1] ]);
  maxy = max([ for (xy = shape) xy[1], for (xy = shape) xy[1] ]);
  for (x = [minx + start[0]:raster:maxx])
    for (y = [miny + start[1]:raster:maxy])
      if ((distance([ x, y ], len(shape) > 0 ? polyRound(shape) : []) >= mindist) &&
          (is_undef(cutouts[0])?true:distance([ x, y ], len(cutouts[0]) > 0 ? polyRound(cutouts[0]) : []) >= mindist) &&
          (is_undef(cutouts[1])?true:distance([ x, y ], len(cutouts[1]) > 0 ? polyRound(cutouts[1]) : []) >= mindist) )
        translate([ x, y, 0 ]) hole(wall, depth);
}

module cage(shapes, cutouts, placements, walls, raster_shifts, chamfer, raster,
            min_hole_distance, noholes = false, markers = false) {
  for (i = [0:len(shapes) - 1])
    translate(placements[i][0]) mirror(placements[i][1])
        rotate(placements[i][2]) difference() {
      cage_wall(shapes[i], cutouts[i], walls[i], chamfer, markers);
      if (!noholes)
        wall_holes(shapes[i], cutouts[i], walls[i], raster, min_hole_distance,
                   raster_shifts[i]);
    }
  if (!noholes)
    connectors();

  module
  connectors() { // those corner parts that connect 4 sides of the cage together
    for (i = [0:len(shapes) - 1])
      hull() intersection() {
        nexti = i + 1 < len(shapes) ? i + 1 : 0;
        translate(placements[i][0]) mirror(placements[i][1])
            rotate(placements[i][2]) translate([ -150, -150, -chamfer ])
                cube([ 300, 300, walls[i] ]);
        translate(placements[nexti][0]) mirror(placements[nexti][1])
            rotate(placements[nexti][2]) translate([ -150, -150, -chamfer ])
                cube([ 300, 300, walls[nexti] ]);
        cage(shapes = shapes, cutouts = cutouts, placements = placements,
             walls = walls, raster_shifts = raster_shifts, chamfer = chamfer,
             raster = raster, min_hole_distance = min_hole_distance,
             noholes = true);
      }
  }
}

// uncomment the following module if you don't have the experimental roof()
// feature turned on in Openscad. This implementation is slower but would work
// on older releases of OpenSCAD
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