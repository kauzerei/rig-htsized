use<include/spline.scad>
function decimate(poly, m) =
    len(poly) < 3 ? poly
    : norm(poly[0] - poly[1]) < m
        ? decimate([ poly[0], for (i = [2:len(poly) - 1]) poly[i] ], m)
        : [ poly[0], each decimate([for (i = [1:len(poly) - 1]) poly[i]], m) ];
$fn = 64 / 1;
bissl = 1 / 100;
thickness = 30;
rosette_mount_length = 32;
rosette_mount_offset=30;
slot = 12;
nut_d = 9;
nut_h = 4;
wall = 3.2;
hole_d = 4.5;
part = "side_handle"; //[side_handle, tube_handle, handle_rosette_mount, handle_screw_washer]
module skew_extrude(list, d, reverse) {
  for (i = [0:len(list) - 2]) {
    startx = list[i][0];
    startz = list[i][1] + d * (reverse ? -1 : 1) / 2;
    h = list[i + 1][0] - list[i][0];
    shift = list[i + 1][1] - list[i][1];
    multmatrix(m = [[d, 0, shift, startz], [0, d, 0, 0], [0, 0, h, startx]]) {
      cylinder(d = 1, h = 1);
      translate([ reverse ? -10 : 0, -0.5, 0 ]) cube([ 10, 1, 1 ]);
    }
  }
}

module handle(front, back, thickness, reverse = false) {
  intersection() {
    skew_extrude(list = decimate(smooth(front, 6), 1), d = 30,
                 reverse = reverse);
    skew_extrude(list = decimate(smooth(back, 6), 1), d = 30,
                 reverse = !reverse);
  }
}

module side_handle() {
  front = [
    [ 0, -55 ], [ 15, -54 ], [ 26, -52 ], [ 38, -49 ], [ 48, -45 ], [ 60, -37 ],
    [ 73, -27 ], [ 86, -18 ], [ 101, -6 ], [ 107, 9 ]
  ];
  back = [
    [ 0, 11 ], [ 15, 9 ], [ 25, 21 ], [ 38, 19 ], [ 48, 30 ], [ 60, 28 ],
    [ 73, 38 ], [ 86, 36 ], [ 101, 47 ], [ 107, 47 ]
  ];
  difference() {
    handle(front, back, thickness);
    hull() for (tr = [ [ -31, 0, 10 ], [ 2, 0, 80 ] ]) translate(tr)
        rotate([ 90, 0, 0 ]) cylinder(d = hole_d, h = 31, center = true);
    hull() for (tr = [ [ -31, -1.6, 10 ], [ 2, -wall / 2, 80 ] ]) translate(tr)
        rotate([ 90, 0, 0 ]) cylinder(d = slot, h = 31);
    hull() for (tr = [ [ -31, 1.6, 10 ], [ 2, wall / 2, 80 ] ]) translate(tr)
        rotate([ -90, 0, 0 ]) cylinder(d = slot, h = 31);
  }
}

module handle_rosette_mount() {
  difference() {
    cube([ rosette_mount_length, slot - 1, rosette_mount_offset ]);
    for (tr = [ [ rosette_mount_length/2-10, (slot-1)/2, -bissl ], [ rosette_mount_length/2, (slot-1)/2, -bissl ], [ rosette_mount_length/2+10, (slot-1)/2, -bissl ] ])
      translate(tr) cylinder(d = hole_d, h = rosette_mount_offset + 2 * bissl);
    for (tr = [[ rosette_mount_length/2-10, (slot-1)/2, wall ],[rosette_mount_length/2+10, (slot-1)/2, wall]])
      translate(tr) cylinder(d = nut_d, h = rosette_mount_offset,$fn=6);
  }
}

module handle_screw_washer() {
  difference() {
    cube([slot - 1, rosette_mount_length, wall], center = true);
    cylinder(d = hole_d, h = wall + bissl, center = true);
  }
}

module tube_handle() {
  front = [
    [0, 17], [12, 12], [24, 15], [33, 14], [47, 19], [57, 17], [72, 22], [83, 20], [100, 25]                       
  ];
  back = [
    [0, -23], [12, -23], [25, -23], [33, -23], [47, -19], [57, -15], [72, -12], [83, -12], [100, -15]
  ];
  difference() {
    handle(back, front, thickness);
    translate([0, 0, wall]) cylinder(d = 16, h = 100);
    translate([0, 0, -bissl]) cylinder(d = hole_d, h = wall + 2 *bissl);
  }
}

if (part == "side_handle")
  side_handle();
if (part == "handle_rosette_mount")
  handle_rosette_mount();
if (part == "handle_screw_washer")
  handle_screw_washer();
if (part == "tube_handle")
  tube_handle();