//Everything that has to do with mounting 
$fn = 64;
bissl = 1 / 100;
alot = 200 / 1;
part = "spacer_skew"; //[spacer_skew, spacer_straight, double_clamp_skew, double_clamp_nut_mount, double_clamp_bolt_mount, double_clamp_side_mount, single_clamp]

/* [global part parameters] */
part_depth = 10;
offset = 10;
wall = 3;

/* [holes parameters] :*/
nut_h = 4;
nut_d = 8;
hole_d = 4.5;
raster = 10;

/* [rails parameters] */
rods_distance = 60;
rod_d = 15;

/* [spacer parameters:] */
spacer_height = 35;
spacer_width = 60;
rounding_radius = 5;

/* [side mount parameters:] */
side_mount_thickness=5;
side_mount_width=32;

module spacer(height = 35, width = 60, depth = 10, radius = 5, wall = 2,
              nut_h = 4, nut_d = 8, hole_d = 4.5, offset = 10, raster = 10) {
  thickness = wall + nut_h;
  r = max(bissl, radius - thickness);
  difference() {
    intersection() {
      hull() for (tr = [
                        [ 0, -offset / 2, height / 2 - thickness / 2 ],
                        [ 0, offset / 2, -height / 2 + thickness / 2 ],
                      ]) translate(tr)
          cube([ width, depth, thickness ], center = true);
      hull() for (tr = [
                        [ -width / 2 + radius, 0, -height / 2 + radius ],
                        [ width / 2 - radius, 0, -height / 2 + radius ],
                        [ -width / 2 + radius, 0, height / 2 - radius ],
                        [ width / 2 - radius, 0, height / 2 - radius ]
                      ]) translate(tr) rotate([ 90, 0, 0 ])
          cylinder(r = radius, h = offset + depth + bissl, center = true);
    }
    hull() for (tr = [
              [ -width / 2 + thickness + r, 0, -height / 2 + thickness + r ],
              [ width / 2 - thickness - r, 0, -height / 2 + thickness + r ],
              [ -width / 2 + thickness + r, 0, height / 2 - thickness - r ],
              [ width / 2 - thickness - r, 0, height / 2 - thickness - r ]
            ]) translate(tr) rotate([ 90, 0, 0 ])
        cylinder(r = r, h = offset + depth + bissl, center = true);

    // upper_holes
    startx = (width / 2 - thickness - r - nut_d / 2) % raster -
             (width / 2 - thickness - r - nut_d / 2);
    for (x = [startx:raster:width / 2 - thickness - r - nut_d / 2])
      translate([ x, -offset / 2, height / 2 - thickness - 2 * bissl ]) {
        cylinder(d = hole_d, h = thickness + 3 * bissl);
      }

    // lower holes
    for (x = [startx:raster:width / 2 - thickness - r - nut_d / 2])
      translate([ x, offset / 2, -height / 2 - bissl ]) {
        cylinder(d = hole_d, h = thickness + 3 * bissl);
        translate([ 0, 0, wall + bissl ])
            cylinder(d = nut_d, h = nut_h + 2 * bissl, $fn = 6);
      }

    // remove screwdriver collision
    translate(
        [ -(width - 2 * thickness) / 2, -depth / 2 - offset / 2, -height / 2 ])
        cube([ width - 2 * thickness, offset, height / 2 ]);
  }
}

module double_clamp(rod_d = 15, rods_distance = 60, depth = 10, wall = 3,
                    nut_h = 4, nut_d = 8, hole_d = 4.5, offset = 10,
                    raster = 10, extraflat = true, short = false, nut_side=true, bolt_side=true) {
  thickness = wall + nut_h;
  height = rod_d + 2 * wall;
  mirror([ 0, 0, 0 ]) translate([ rods_distance / 2, 0, 0 ])
      clamp(rod_d = rod_d, depth = depth, wall = wall, nut_h = nut_h,
            nut_d = nut_d, hole_d = hole_d, offset = offset, short = short);
  mirror([ 1, 0, 0 ]) translate([ rods_distance / 2, 0, 0 ])
      clamp(rod_d = rod_d, depth = depth, wall = wall, nut_h = nut_h,
            nut_d = nut_d, hole_d = hole_d, offset = offset, short = short);
  difference() {
    hull() {
      if(nut_side)translate([ 0, offset / 2, -height / 2 + thickness / 2 ]) cube([ rods_distance, depth, thickness ], center = true);
      if(bolt_side)translate([ 0, -offset / 2, height / 2 - thickness / 2 ]) cube([ rods_distance, depth, thickness ], center = true);
    }
    flat = extraflat ? (part_depth - nut_d) / 2
                     : 0; // extra flat space for ease of printing.
    translate([
      -(rods_distance + bissl) / 2, -(depth + offset + bissl) / 2 - flat,
      -(height - 2 * thickness) / 2
    ])
        cube([rods_distance + bissl, depth + offset + bissl, height - 2 * thickness]);
    // upper_holes
    startx = (rods_distance / 2 - rod_d / 2 - wall - nut_d / 2) % raster -
             (rods_distance / 2 - rod_d / 2 - wall - nut_d / 2);
    for (x = [startx:raster:rods_distance / 2 - rod_d / 2 - wall - nut_d / 2])
      translate([ x, -offset / 2, height / 2 - thickness - 2 * bissl ]) {
        cylinder(d = hole_d, h = thickness + 3 * bissl);
      }

    // lower holes
    for (x = [startx:raster:rods_distance / 2 - thickness - nut_d / 2])
      translate([ x, offset / 2, -height / 2 - bissl ]) {
        cylinder(d = hole_d, h = thickness + 3 * bissl);
        translate([ 0, 0, wall + bissl ])
            cylinder(d = nut_d, h = nut_h + 2 * bissl, $fn = 6);
      }

    // remove screwdriver collision
    translate([ -rods_distance / 2, -depth / 2 - offset / 2, -height / 2 ])
        cube([ rods_distance, offset, height / 2 ]);
    translate([ rods_distance / 2, 0, 0 ])
        clamp(rod_d = rod_d, depth = depth, wall = wall, nut_h = nut_h,
              nut_d = nut_d, hole_d = hole_d, offset = offset, negative = true);
    mirror([ 1, 0, 0 ]) translate([ rods_distance / 2, 0, 0 ])
        clamp(rod_d = rod_d, depth = depth, wall = wall, nut_h = nut_h,
              nut_d = nut_d, hole_d = hole_d, offset = offset, negative = true);
  }
}

module double_clamp_side_mount(rod_d = 15, rods_distance = 60, depth = 10, wall = 3,
                    nut_h = 4, nut_d = 8, hole_d = 4.5, raster = 10, thickness, width) {
  difference() {
    union() {
      mirror([ 0, 0, 0 ]) translate([ rods_distance / 2, 0, 0 ])
      clamp(rod_d = rod_d, depth = depth, wall = wall, nut_h = nut_h,
            nut_d = nut_d, hole_d = hole_d, offset = 0, short = true);
      mirror([ 1, 0, 0 ]) translate([ rods_distance / 2, 0, 0 ])
      clamp(rod_d = rod_d, depth = depth, wall = wall, nut_h = nut_h,
            nut_d = nut_d, hole_d = hole_d, offset = 0, short = true);
    cube([rods_distance,depth,rod_d+2*wall],center=true);
    }
    mirror([ 0, 0, 0 ]) translate([ rods_distance / 2, 0, 0 ])
      clamp(rod_d = rod_d, depth = depth, wall = wall, nut_h = nut_h,
            nut_d = nut_d, hole_d = hole_d, offset = 0, short = true, negative = true);
    mirror([ 1, 0, 0 ]) translate([ rods_distance / 2, 0, 0 ])
      clamp(rod_d = rod_d, depth = depth, wall = wall, nut_h = nut_h,
            nut_d = nut_d, hole_d = hole_d, offset = 0, short = true, negative = true);
    translate([0,wall+nut_h,0])cube([width,depth+bissl,rod_d+2*wall+bissl],center=true);
    startx = (rods_distance / 2 - rod_d / 2 - wall - nut_d / 2) % raster -
             (rods_distance / 2 - rod_d / 2 - wall - nut_d / 2);
    for (x = [startx:raster:rods_distance / 2 - thickness - nut_d / 2])
      rotate([-90,0,0])translate([ x, 0, -depth/2 - bissl ]) {
        cylinder(d = hole_d, h = depth);
        translate([ 0, 0, 0 ])
            cylinder(d = nut_d, h = nut_h, $fn = 6);
      }

  }
}

module clamp(rod_d = 15, depth = 10, wall = 3, nut_h = 4, nut_d = 8,
             hole_d = 4.5, offset = 10, negative = false, short = false) {
  thickness = wall + nut_h;
  height = rod_d + 2 * wall;
  angle = atan(offset / (height - thickness));
  d = thickness * sin(angle) + depth * cos(angle);
  h = (rod_d + 2 * wall) / cos(angle) - d * tan(angle);
  length = short ? height / 2 : height / 2 + d / 2;
  difference() {
    if (!negative)
      intersection() {
        hull() for (tr = [ // skewed shape
                          [ 0, -offset / 2, height / 2 - thickness / 2 ],
                          [ 0, offset / 2, -height / 2 + thickness / 2 ],
                        ]) translate(tr)
            cube([ rods_distance, depth, thickness ], center = true);
        union() {
          rotate([ 90, 0, 0 ])
              cylinder(d = rod_d + 2 * wall, h = depth + offset, center = true); // outer cylinder shape
          rotate([ angle, 0, 0 ]) {    // tightening protrusion
            translate([ length, 0, 0 ]) cylinder(d = d, h = h, center = true);
            translate([ 0, -d / 2, -h / 2 ]) cube([ length, d, h ]);
          }
        }
      }
    union() {
      rotate([ 90, 0, 0 ]) cylinder(d = rod_d, h = depth + offset + bissl,
                                    center = true); // place for rod
      rotate([ angle, 0, 0 ])
          translate([ 0, -d / 2 - bissl, -(h - 2 * thickness) / 2 ]) cube([
            d + height / 2, d + 2 * bissl, h - 2 * thickness
          ]); // tightening gap
      rotate([ angle, 0, 0 ]) translate([ length, 0, 0 ])
          cylinder(d = hole_d, h = h + bissl, center = true); // tightening hole
      rotate([ angle, 0, 0 ])
          translate([ length, 0, (h - 2 * thickness) / 2 + wall ])
              cylinder(d = nut_d, h = h + bissl, $fn = 6); // nut insert
    }
  }
}

if (part == "spacer_skew")
  rotate([ -90 - atan(offset / (spacer_height - wall)), 0, 0 ])
      spacer(height = spacer_height, width = spacer_width, depth = part_depth,
             radius = rounding_radius, wall = wall, nut_h = nut_h,
             nut_d = nut_d, hole_d = hole_d, offset = offset, raster = raster);
if (part == "spacer_straight")
  rotate([ 90, 0, 0 ])
      spacer(height = spacer_height, width = spacer_width, depth = part_depth,
             radius = rounding_radius, wall = wall, nut_h = nut_h,
             nut_d = nut_d, hole_d = hole_d, offset = 0, raster = raster);
if (part == "double_clamp_skew")
  rotate([ -90 - atan(offset / (rod_d + 2 * wall - wall - nut_h)), 0, 0 ])
      double_clamp(rod_d = rod_d, rods_distance = rods_distance,
                   depth = part_depth, wall = wall, nut_h = nut_h,
                   nut_d = nut_d, hole_d = hole_d, offset = offset,
                   raster = raster);
if (part == "double_clamp_straight")
  rotate([ 90, 0, 0 ])
      double_clamp(rod_d = rod_d, rods_distance = rods_distance,
                   depth = part_depth, wall = wall, nut_h = nut_h,
                   nut_d = nut_d, hole_d = hole_d, offset = 0, raster = raster,
                   extraflat = false, short = true);
if (part == "single_clamp")
  rotate([ 90, 0, 0 ])
      clamp(rod_d = rod_d, depth = part_depth, wall = wall, nut_h = nut_h,
            nut_d = nut_d, hole_d = hole_d, offset = 0, short = true);
if (part == "double_clamp_nut_mount") rotate([90, 0, 0]) 
    double_clamp(rod_d = rod_d, rods_distance = rods_distance,
                 depth = part_depth, wall = wall, nut_h = nut_h,
                 nut_d = nut_d, hole_d = hole_d, offset = 0, raster = raster,
                 extraflat = false, short = true, bolt_side=false);
if (part == "double_clamp_bolt_mount") rotate([90, 0, 0]) 
    double_clamp(rod_d = rod_d, rods_distance = rods_distance,
                 depth = part_depth, wall = wall, nut_h = nut_h,
                 nut_d = nut_d, hole_d = hole_d, offset = 0, raster = raster,
                 extraflat = false, short = true, nut_side=false);
if (part == "double_clamp_side_mount") rotate([-90, 0, 0]) 
    double_clamp_side_mount(rod_d = rod_d, rods_distance = rods_distance,
                            depth = wall+nut_h+side_mount_thickness,
                            wall = wall, nut_h = nut_h, nut_d = nut_d, 
                            hole_d = hole_d, raster = raster,
                            thickness = side_mount_thickness, width = side_mount_width);