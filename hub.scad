include <constants.scad>
// all units are in mm

MAJOR_DIA = inch_to_mm(SPOOL_INNER_DIA + 1);
MINOR_DIA = inch_to_mm(.5);
ROD_DIA_MM = inch_to_mm(ROD_DIA);

HUB_DEPTH = inch_to_mm(1);
SCREW_LENGTH = inch_to_mm(.5);

module place_mount_screws(dist, n = 4) {
  i = 360/n;
  for(a = [0:i:360]) {
    rotate(a)
    translate([0, dist / 2, 0])
      children();
  }
}

module 770_mount() {
  dist = inch_to_mm(0.770);
  rotate([0, 0, 45])
  place_mount_screws(dist) {
    children();
  }
}

difference() {
  cylinder(d1 = MAJOR_DIA, d2 = MINOR_DIA, h = HUB_DEPTH, $fn=256);
  translate([0, 0, -d])
    cylinder(d = ROD_DIA_MM, h = HUB_DEPTH + d2, $fn = 256);
  770_mount() {
    //threads
    cylinder(d=inch_to_mm(0.135), h=SCREW_LENGTH);
    //head
    translate([0, 0, SCREW_LENGTH - d])
      cylinder(d=inch_to_mm(0.25), h=HUB_DEPTH - SCREW_LENGTH);
  }
}