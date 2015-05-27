// Raspberry Pi B+ case
// By Rodrigo Chandia http://regelatwork.blogspot.com/
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
use <n7.scad>

// How much space to leave between pieces due to printer tolerances
e = 0.3;
boxThick = 2;

makeTop = true;
makeBottom = true;
makeClips = true;
roundClips = false;

drawAll = !makeTop && !makeBottom && !makeClips;

boardX = 56.1;
boardY = 84.9;
boardZ = 4.0;
boardW = 1.45;

holeDiameter = 2.69;
holeRadius = holeDiameter / 2;
hole1X = 4.94 - holeRadius;
hole1Y = 5.23 - holeRadius;
hole2X = 54.22 - holeRadius;
hole2Y = 62.97 - holeRadius;

holes = [
  [hole1X,hole1Y],
  [hole1X,hole2Y],
  [hole2X,hole1Y],
  [hole2X,hole2Y],
];

// Component coords start from corner near PWR led and the top of the PCB
// Third element is which way the connector points to
gpio = [[0.75,7.1,0],[6.42, 57.8, 10],[0,0,1]];
gpioCable = [[0.75,7.1,8],[6.42, 57.8, 10],[-1,0,0]];
pwr = [[51.1,6.85,-0.2],[57.1,14.6,2.69],[1,0,0]];
hdmi = [[44.64,24.8,0],[57.23,39.8,6.57],[1,0,0]];
display = [[20.23,3.56,0],[37.66,4.56,6.1],[0,0,1]];
camera = [[36.43,44.52,0],[54.28,45.52,6.1],[0,0,1]];
audio = [[43.55,50.51,0],[58.55,57.39,7.38],[1,0,0]];
usb1 = [[1.54,69.85,0],[17.22,87.46,16.64],[0,1,0]];
usb2 = [[19.6,69.85,0],[34.92,87.46,16.64],[0,1,0]];
rj45 = [[38.32,66.73,0],[54.08,87.13,14.3],[0,1,0]];
sdcard = [[20.98,0,-boardW-1.34],[34.1,15.41,-boardW],[0,-1,0]];
sdcardHole = [[20,-boxThick,-boardW-1.34],[35,0,-boardW],[0,-1,-1]];

gpioHoleOnSide = true;

allComponents = [
  gpio,
  pwr,
  hdmi,
  display,
  camera,
  audio,
  usb1,
  usb2,
  rj45,
  sdcard,
  sdcardHole,
];

allHoles = [
  gpioCable,
  pwr,
  hdmi,
  display,
  camera,
  audio,
  usb1,
  usb2,
  rj45,
  sdcard,
  sdcardHole,
];

pcb = [[0,0,-boardW],[boardX, boardY, 0],[0,0,0]];

boxHeight = rj45[1][2];

module draw_component(c) {
  translate(c[0]) {
    cube(c[1]-c[0]);
  }
}

module draw_hole(h) {
  translate([h[0],h[1],-boardW-e]) {
    cylinder(r=holeRadius, h=boardW+2*e, center=false, $fs=1);
  }
}

module draw_all_components() {
  for (c = allComponents) {
    draw_component(c);
  }
}

module draw_board() {
  color("green") {
    difference() {
      draw_component(pcb);
      for (h = holes) {
        draw_hole(h);
      }
    }
  }
  color("white"){
    draw_all_components();
  }
}

// projection of u onto v
function proj(u,v) = (u*v/norm(v)*norm(v))*v;

function cont(a,b) = (a * b) > 0 || b == 0;

function vector_contains(c,i) = cont(c[0],i[0]) && cont(c[1],i[1]) && cont(c[2],i[2]);

module make_part_hole(c) {
  hull() {
    for (x = [-1:1], y = [-1:1], z = [-1:1]) {
      if (vector_contains(c[2],[x,y,z])) {
        translate([x,y,z] * 20) {
          minkowski() {
            draw_component(c);
            cube([2*e,2*e,2*e],center=true);
          }
        }
      }
    }
  }
}

module make_all_holes() {
  components = gpioHoleOnSide? allHoles : allComponents;
  for (c = components) {
    make_part_hole(c);
  }
}

module make_rounded_box(x,y,z,r) {
  translate([r,r,0])
  minkowski() {
    cylinder(r=r, h=r, $fs=0.5);
    cube([x-2*r,y-2*r,z-2*r]);
  }
}

module make_box(h) {
    difference() {
      translate([-boxThick-e,-boxThick-e,-boxThick-boardZ])
      make_rounded_box(
        boardX + 2*boxThick + 2*e,
        boardY + 2*boxThick + 2*e,
        boardZ + h + 2*boxThick,
        boxThick);
      difference() {
        translate([-e,-e,-boardZ])
        cube([boardX+2*e, boardY+2*e, h+boardZ-boxThick]);
        half_cube(
          [rj45[0][0]-0.01,rj45[0][1],boxHeight - boxThick + e],
          [usb1[1][0]+0.01,boardY+e,0]);
      }
   }
}

module make_logo() {
  s=0.45;
  rotate([0,0,90])
  translate([32.7,-10,0])
  scale([s,s,1]) {
//    linear_extrude(height=boxThick + 2*e) {
//      import("n7.dxf", convexity=10);
        rotate([0,0,180])
//    }
      n7_logo(boxThick + 2*e);
  }
}

module make_pcb_support(c, isTop) {
  bottom = isTop ? 0 : -boardZ - 0.01;
  top = isTop ? boxHeight - boxThick + 0.01 : boardZ - boardW + 0.01;
  translate([c[0],c[1],bottom])
  cylinder(d=5,h=top,$fs=1);
}

module make_all_supports(isTop) {
  for (i=holes) {
    make_pcb_support(i, isTop);
  }
}

module make_dents(i,isTop) {
  dent_height = isTop ? boxHeight + boxThick / 3 : -boardZ - boxThick * 4 / 3 ;
  translate([i[0],i[1],dent_height])
  rotate([90,0,0])
  cylinder(r=boxThick,h=boxThick*2,center=true,$fs=0.5);
}

module make_all_dents() {
  for (i=holes) {
    make_dents(i,isTop = true);
    make_dents(i,isTop = false);
  }
}

module box_with_holes() {
  difference() {
    make_box(boxHeight);
    translate([0, 0, boxHeight -boxThick - e]) {
      make_logo();
    }
    translate([0, 0, -boardZ - boxThick - e]) {
      mirror([0,1,0])
      translate([0,-65.7,0])
      make_logo();
    }
    make_all_holes();
    make_all_dents();
  }
}

module half_cube(p1, p2) {
  polyhedron(points=[
    p1,
    [p1[0],p2[1],p1[2]],
    [p1[0],p2[1],p2[2]],
    [p2[0],p1[1],p1[2]],
    [p2[0],p2[1],p1[2]],
    p2
  ], faces=[
    [0,1,2],
    [1,5,2],
    [1,4,5],
    [0,4,1],
    [0,3,4],
    [0,2,5],
    [0,5,3],
    [3,5,4],
  ]);
}

module simple_cube(p1, p2) {
  translate(p1)
  cube(p2-p1);
}

module cut_solid(isTop) {
  side = 2*e + boxThick;
  offset = isTop ? e : 0;
  difference() {
    simple_cube(
      [-side, -side, 0],
      [boardX + side, boardY + side, boxHeight + 2*side]
    );
    simple_cube(
      [-2*side,-2*side,-2*e],
      [sdcardHole[0][0]-6+offset, gpioCable[1][1] + offset, gpioCable[0][2] -e + 0.01]
    );
    simple_cube(
      [sdcardHole[1][0]+6-offset, -2*side, -2*e],
      [boardX + 2*side, audio[1][1] + 15 + offset, pwr[1][2] + e - 0.01]
    );
    simple_cube(
      [-2*side,gpioCable[1][1]-2*e,-e],
      [boxThick,usb1[0][1]+2*e,(boxHeight - boxThick) / 3]
    );
    simple_cube(
      [-2*side, usb1[0][1]-offset, -2*e],
      [usb1[1][0], boardY + 2*side, (boxHeight - boxThick) / 2]
    );
  }

  simple_cube(
    [sdcardHole[0][0]-6 + offset, -side, sdcardHole[1][2] + e-0.01],
    [sdcardHole[1][0]+6 - offset, 10, e]
  );
}

module bottom_box() {
  difference() {
    box_with_holes();
    cut_solid(isTop=false);
  }
  make_all_supports(isTop = false);
}

module top_box() {
  intersection() {
    box_with_holes();
    cut_solid(isTop=true);
  }
  make_all_supports(isTop = true);
}

if (drawAll) {
  top_box();
  bottom_box();
  draw_board();
  translate([holes[0][0],holes[0][1] + boxThick - e,boardZ])
  rotate([90,0,0])
  make_clip();
  translate([holes[1][0],holes[1][1] + boxThick - e,boardZ])
  rotate([90,0,0])
  make_clip();
  translate([holes[2][0],holes[2][1] - boxThick + e,boardZ])
  rotate([90,0,180])
  make_clip();
  translate([holes[3][0],holes[3][1] - boxThick + e,boardZ])
  rotate([90,0,180])
  make_clip();
}

if (makeBottom) {
  translate([boxThick*2,boxThick,boardZ + boxThick])
  bottom_box();
}

if (makeTop) {
  translate([-boxThick*2,boxThick,boxHeight])
  rotate([0,180,0])
  top_box();
}

totalHeigth = boxHeight + boardZ + boxThick;
module half_clip() {
  translate([0,totalHeigth/2 + boxThick/3,0])
  cylinder(r=boxThick, h=boxThick*2 - 2*e, center=false, $fs=0.01);
  translate([-2.5*boxThick - holes[0][0],0,0])
  cube([boxThick,totalHeigth/2,boxThick*2 - 2*e]);
  if (roundClips) {
    translate([-2.5*boxThick - holes[0][0],0,0])
    cube([boxThick,totalHeigth/2,boxThick*2 - 2*e]);
    difference() {
      translate([(-2.5*boxThick - holes[0][0])/2 + boxThick/2,totalHeigth/2,0]) {
        cylinder(d=3.5*boxThick + holes[0][0], h=boxThick*2 - 2*e, center=false, $fs=0.01);
      }
      translate([(-2.5*boxThick - holes[0][0])/2 + boxThick/2,totalHeigth/2,-e]) {
        cylinder(d=1.5*boxThick + holes[0][0], h=boxThick*2, center=false, $fs=0.01);
      }
      translate([-1.5*boxThick - holes[0][0],totalHeigth/2 - 7*boxThick + holes[0][0],-e])
      cube([3.5*boxThick + holes[0][0],3.5*boxThick + holes[0][0],boxThick*2 + e]);
    }
  } else {
    translate([-2.5*boxThick - holes[0][0],totalHeigth/2 + boxThick/3,0])
    cube([3.5*boxThick +holes[0][0],boxThick,boxThick*2 - 2*e]);
    translate([-2.5*boxThick - holes[0][0],0,0])
    cube([boxThick,totalHeigth/2 + boxThick,boxThick*2 - 2*e]);
  }
}

module make_clip() {
  half_clip();
  mirror([0,1,0])
  half_clip();
}

if (makeClips) {
  translate([-60,-30,0])
  rotate([0,0,90])
  for (x = [0,totalHeigth], y = [-20 - totalHeigth, -40 - 2 * totalHeigth]) {
    translate([x,y,0]) {
      make_clip();
    }
  }
}