include <constants.scad>

// all units are in inches

DRAW_PARTS = false;
MATERIAL_THICKNESS = .5;

PART_SPACING = 1;

FIT_CLEARANCE = 1 / 32;

BASE_LENGTH = SPOOL_DIA + 2 * SPOOL_CLEARANCE;
BASE_DEPTH = SPOOL_DEPTH + 2 * SPOOL_CLEARANCE;
BASE_HEIGHT = 2 * MATERIAL_THICKNESS;

ROD_CLEARANCE = 1/16;
ROD_INSET = 1.5;

SUPPORT_WIDTH = 6;
SUPPORT_HEIGHT = BASE_HEIGHT + SPOOL_DIA / 2 + SPOOL_CLEARANCE + ROD_INSET;

FILAMENT_DIA = 1 / 4;
FILAMENT_INSET = 1.25;
FILAMENT_HEIGHT = SPOOL_CLEARANCE + 1;

GUIDE_WIDTH = 3;
GUIDE_HEIGHT = BASE_HEIGHT + FILAMENT_HEIGHT + FILAMENT_INSET;

module base() {
  difference() {
    cube([BASE_LENGTH, BASE_DEPTH, MATERIAL_THICKNESS]);

    //cutout for supports
    translate([(BASE_LENGTH / 2 - SUPPORT_WIDTH / 2) - FIT_CLEARANCE, -d, -d])
      cube([SUPPORT_WIDTH + 2 * FIT_CLEARANCE, MATERIAL_THICKNESS + FIT_CLEARANCE + d2, MATERIAL_THICKNESS + d2]);

    translate([(BASE_LENGTH / 2 - SUPPORT_WIDTH / 2) - FIT_CLEARANCE, BASE_DEPTH - MATERIAL_THICKNESS - FIT_CLEARANCE - d, -d])
      cube([SUPPORT_WIDTH + 2 * FIT_CLEARANCE, MATERIAL_THICKNESS + FIT_CLEARANCE + d2, MATERIAL_THICKNESS + d2]);

    //cutout for guide
    translate([MATERIAL_THICKNESS - d, BASE_DEPTH / 2 - GUIDE_WIDTH / 2 - FIT_CLEARANCE, -d])
    rotate([0, 0, 90])
      cube([GUIDE_WIDTH + 2 * FIT_CLEARANCE, MATERIAL_THICKNESS + FIT_CLEARANCE + d2, MATERIAL_THICKNESS + d2]);
  }
}

module guide() {
  slot_h = GUIDE_HEIGHT - 2 * FILAMENT_INSET;
  difference() {
    cube([GUIDE_WIDTH, GUIDE_HEIGHT, MATERIAL_THICKNESS]);
    translate([GUIDE_WIDTH / 2 - FILAMENT_DIA / 2, FILAMENT_INSET + d, -d])
    union() {
      cube([FILAMENT_DIA, slot_h, MATERIAL_THICKNESS + d2]);
      translate([FILAMENT_DIA / 2, slot_h, 0])
        cylinder(d = FILAMENT_DIA, h = MATERIAL_THICKNESS + d2);
      translate([FILAMENT_DIA / 2, 0, 0])
        cylinder(d = FILAMENT_DIA, h = MATERIAL_THICKNESS + d2);
    }
  }
}

module support() {
  slot_w = ROD_DIA + 2 * ROD_CLEARANCE;
  difference() {
    cube([SUPPORT_WIDTH, SUPPORT_HEIGHT, MATERIAL_THICKNESS]);
    //slot for rod
    translate([SUPPORT_WIDTH / 2 - ROD_DIA / 2 - ROD_CLEARANCE, SUPPORT_HEIGHT - ROD_CLEARANCE - ROD_INSET - ROD_DIA / 2, -d])
    union() {
      cube([slot_w, ROD_INSET + ROD_DIA, MATERIAL_THICKNESS + d2]);
      translate([slot_w / 2, 0, 0])
      cylinder(d = ROD_DIA + 2 * ROD_CLEARANCE, h = MATERIAL_THICKNESS + d2, $fn=128);
    }
  }
}

if (DRAW_PARTS) {
  projection(cut=true)
  union() {
    support();
    translate([SUPPORT_WIDTH + PART_SPACING, 0, 0])
      support();

    translate([0, SUPPORT_HEIGHT + PART_SPACING, 0])
      base();

    translate([0, SUPPORT_HEIGHT + PART_SPACING + BASE_DEPTH + PART_SPACING, 0])
      base();

    translate([2 * (SUPPORT_WIDTH + PART_SPACING), 0, 0])
      guide();

    translate([2 * (SUPPORT_WIDTH + PART_SPACING), GUIDE_HEIGHT + PART_SPACING, 0])
      guide();
  }
} else {
  base();

  translate([0, 0, MATERIAL_THICKNESS])
    base();

  translate([(BASE_LENGTH / 2 - SUPPORT_WIDTH / 2), MATERIAL_THICKNESS, 0])
  rotate([90, 0, 0])
    support();

  translate([BASE_LENGTH / 2 - SUPPORT_WIDTH / 2, BASE_DEPTH , 0])
  rotate([90, 0, 0])
    support();

  translate([0, BASE_DEPTH / 2 - GUIDE_WIDTH / 2, 0])
  rotate([90, 0, 90])
  guide();
}
