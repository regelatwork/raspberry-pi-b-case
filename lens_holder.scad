// An arm to hold lenses for a farsighted camera

// Standard lego ball size
ball_r = 10.2/2;
ball_arm = ball_r + 10;
arm_l = 46.83;
side_arm_l = 40;
thick = 3.3;

module side_arm(x) {
  translate([x,-thick/2,0])
  cube([thick,side_arm_l,thick]);
}

translate([0,0,ball_r])
sphere(r=ball_r,$fn=50);
cylinder(d=thick,h=thick,$fn=20);
translate([0,-thick/2,0])
cube([ball_arm + arm_l,thick,thick]);
side_arm(ball_arm);
side_arm(arm_l+ball_arm-thick);