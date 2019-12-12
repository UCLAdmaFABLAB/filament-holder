include <constants.scad>
include <utils.scad>
// all units are in mm

ROD_DIA_MM = inch_to_mm(ROD_DIA) + 1;
HUB_DIA = inch_to_mm(1.25);
ARM_LEN = inch_to_mm(3);
ARM_THICKNESS = inch_to_mm(0.5);
HANDLE_DIA = inch_to_mm(1.25);
HANDLE_LEN = inch_to_mm(4);
SCREW_DIA = inch_to_mm(0.15);

module hub() {
  difference() {
    cylinder(d = HUB_DIA, h=ARM_THICKNESS);
    770_mount() {
      translate([0, 0, -d])
        cylinder(d=SCREW_DIA, h=ARM_THICKNESS + d2);
    }
    translate([0, 0, -d])
    cylinder(d = ROD_DIA_MM, h = ARM_THICKNESS + d2, $fn = 256);
  }
}

module arm() {
  difference(){
    translate([0, -HUB_DIA / 2, 0])
      cube([ARM_LEN, HUB_DIA, ARM_THICKNESS]);
    translate([0, 0, -d])
      cylinder(d = HUB_DIA - 1, h=ARM_THICKNESS + d2);
  }
  translate([ARM_LEN, 0, 0])
    cylinder(d = HUB_DIA, h=ARM_THICKNESS + d2);
}

module handle() {
  translate([ARM_LEN, 0, 0])
  rotate_extrude() {
  rotate([0, 0, 90])
    difference() {
      translate([HANDLE_LEN / 2, 0, 0])
      resize([HANDLE_LEN,HANDLE_DIA])
        circle(d=20);
      square([HANDLE_LEN, HANDLE_DIA]);
    }
  }
}

hub();
arm();
handle();
