//camera holder with ball joint for raspberry pi camera to fit on a 20mm T slot

thick = 1.5;
e = 0.2;

pcb_x = 25;
pcb_y = 3;
//pcb_z = 24;
// Not full length. Otherwise it bumps against the ribbon cable connector.
pcb_z = 20.14;

ball_r = 5.1;
ball_neck = 2;
ball_holder_z_fraction=3/5;
ball_holder_y_fraction=1/6;
ball_holder_thick=3;

holder_slot = 6;
holder_lid = 20;
holder_len = 6 + 3*thick + ball_holder_thick;
holder_sep = 2.06;

draw_holder = false;
draw_ball_holder = true;
draw_lid = false;
draw_ears = true;

module roundSlab(bodyX,bodyY,bodyZ,t) {
  translate([0,0,-t])
    union() {
      cylinder(d=bodyY,h=bodyZ,$fs=0.5);
      translate([0,-bodyY/2,0])
        cube([bodyX,bodyY,bodyZ]);
    }
    translate([bodyX,0,-t])
    cylinder(d=bodyY,h=bodyZ,$fs=0.5);
}

module holder() {
  translate([thick-e,thick,0])
  difference() {
    roundSlab(pcb_x - 2*thick + 2*e, pcb_y + 2*thick, pcb_z+2*thick, thick);
    translate([0,0,thick])
      roundSlab(pcb_x - 2*thick + 2*e, pcb_y, pcb_z+2*thick+2*e, thick);
    translate([0,0,0])
      cube([pcb_x - 2*thick + 2*e,pcb_y+2*thick,pcb_z+2*thick+2*e]);
  }
}

module ball_joint() {
  translate([pcb_x/2,-ball_r-ball_neck-thick,ball_r-thick])
  union() {
    sphere(r=ball_r,$fs=1);
    translate([-thick,0,-ball_r])
      cube([thick*2,ball_r+ball_neck,ball_r*2]);
    translate([0,0,-ball_r])
    cylinder(r=thick,h=ball_r*2,$fs=0.5);
  }
}

module ball_holder_cut() {
  translate([-ball_r-ball_holder_thick,-ball_r-ball_holder_thick,ball_r*ball_holder_z_fraction])
    cube([2*(ball_r+ball_holder_thick),2*(ball_r+ball_holder_thick),ball_r]);
}

module ball_holder() {
  difference() {
    union() {
      sphere(r=ball_r+ball_holder_thick,$fn=100);
      translate([0,-ball_r - ball_holder_thick - 3*thick,0])
        cube([holder_lid,thick,ball_r*2*ball_holder_z_fraction],center=true);
      translate([0,-ball_r-holder_len/2,0])
        cube([holder_slot,holder_len,ball_r*2*ball_holder_z_fraction],center=true);
    }
    difference() {
      translate([-pcb_x/2,ball_r*ball_holder_y_fraction,-ball_r-thick])
        cube([pcb_x,2*ball_r,2*(ball_r+thick)]);
      translate([0, ball_r*ball_holder_y_fraction, 0])
      rotate ([0,90,0])
        cylinder(r=ball_r*ball_holder_z_fraction, h=(ball_r+ball_holder_thick)*2, center=true, $fn=100);
    }
    ball_holder_cut();
    mirror([0,0,1])
    ball_holder_cut();
    sphere(r=ball_r+e/2,$fn=100);
  }
}

module holder_lid() {
   translate([0,-ball_r-thick*5/2,0])
   difference() {
     cube([holder_lid,2*thick,holder_lid],center=true);
     cube([holder_slot+2*e,thick+2*e,ball_r*2*ball_holder_z_fraction+e],center=true);
     translate([0,0,holder_lid/2])
       cube([holder_slot+2*e,e+2*thick,ball_r*2*ball_holder_z_fraction+2*e + holder_lid],center=true);
     translate([0,-thick/2,0])
       cube([holder_lid+2*e, e+thick, ball_r*2*ball_holder_z_fraction+2*e],center=true);
   }
}

module ear(x,y) {
  translate([x,y,0])
  cylinder(r=5,h=0.2,center=false);
}

if (draw_holder) {
  translate([0,0,thick]) {
    holder();
    ball_joint();
  }
  if (draw_ears) {
    ear(-3,pcb_y/2);
    ear(3+pcb_x,pcb_y/2);
  }
}

if (draw_ball_holder) {
  translate([0,-20,ball_r*ball_holder_z_fraction])
  ball_holder();
  if (draw_ears) {
    ear(0,-20-holder_len-ball_r-3);
    ear(-holder_lid/2-3,-23-holder_len/2-ball_r+ball_holder_thick/2);
    ear(holder_lid/2+3,-23-holder_len/2-ball_r+ball_holder_thick/2);
//    ear(ball_r+3+ball_holder_thick,-22);
//    ear(-ball_r-3-ball_holder_thick,-22);
  }
}

if (draw_lid) {
  translate([-20,0,-thick*3/2-ball_r])
  rotate([-90,0,0])
  holder_lid();
  if (draw_ears) {
    translate([-20,0,0]) {
      ear(holder_lid/2,holder_lid/2);
      ear(-holder_lid/2,-holder_lid/2);
    }
  }
}

if (!draw_holder && !draw_ball_holder && !draw_lid) {
holder();
ball_joint();

translate([
  pcb_x/2,
  -ball_r-ball_neck-thick,
  ball_r-thick])
union() {
  holder_lid();  
  ball_holder();
}
%cube([pcb_x,pcb_y,pcb_z]);
}
