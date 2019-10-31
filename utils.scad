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
