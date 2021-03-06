// original design  http://www.thingiverse.com/thing:1755428 
// Triple A Battery holder version
// AAA box 16.58x58.05x13.59
debug = false;

t = .75;
r = 1.057;
switch_w = 5.9 + 0.2;
switch_d = 10.7+1 * r;

led_d = 5+0.5 * r;

/* [Geral] */
// Printer XY Dimensional Error
printerErrorMargin = 0.5;
/* [Dimensions] */
// Box side size (Y)
// Face of the box (where cover slides in) (X)
boxSizeDepth  = 35;
boxWallThickness = 1.5;
/* [Text] */
// Zero to AUTO
TextCover1 = " A M3x10";
TextCover2 = "";
TextHeight = 0.4;

/* [HIDDEN] */
$fn = 50;
diffMargin = 0.01;

printerErrorMargin = 0.5;
boxWallThickness = 2;
// AAA box 58.05 x 13.14 x 14.65
boxSizeWidth=  58.05 + 24;
boxSizeHeight = 20; 
boxSizeDepth = 13.14 + 4.04; 
coverThickness = 4;
LateralFontSize=6;
TextHeight = 0.5;
TextLateral1 = " @Jonathan75"; //side
TextLateral2 = ""; //side line 2
TextCover1 = ""; //lid
TextCover2 = ""; //lid line 2

if (debug) {
    intersection(){
      translate([0,5,0]) cube([25,10,20]);  
      boxWithHoles();
    }
  //batteryHolder();
} else {
    boxWithHoles();    
    translate([-boxSizeDepth-1,0,0]) cover(); //scale([.95,1,.99])
}



module boxWithHoles(){
  difference(){
    //translate rotate([0,0,180])
    box();
    union(){
      switch();
      ledHole();
    }
  }
  switch(0.9);
  ledHole(0.9);
}

module ledHole(s=1){
  bwt = boxWallThickness*0.5;
  z = (boxSizeHeight-bwt) * 0.5;
  x = (boxSizeDepth) * 0.5;
  translate([x,4.5-2,z]) rotate([90,0,0]) scale([s,s,s]) cylinder(d=led_d,h=boxWallThickness*1.5);
}

module switch(s=1){
  translate([1,15,boxSizeHeight * .5]) scale([s,s,s]) cube([ boxWallThickness+1, switch_d, switch_w], center=true);
}

module box(){
    bwt = boxWallThickness;
     //rotate([0,90,0])
     translate([0, boxSizeWidth, 0]) mirror([0,1,0]) difference(){
        minkowski(){
            translate([0.5,0.5]) cube([boxSizeDepth-1,boxSizeWidth-1,boxSizeHeight-1]);
            cylinder(d=1,h=1);
        }

        translate([bwt,bwt,bwt])
            cube([boxSizeDepth-bwt*2,
                  boxSizeWidth-bwt*2,
                  boxSizeHeight+bwt*2]);
        translate([bwt,
                   -2*diffMargin,
                   boxSizeHeight-coverThickness
                   +diffMargin]){
            cube([boxSizeDepth-bwt*2,bwt*2,
                  coverThickness]);
        }
        d=coverThickness*2/3;
        h=boxSizeWidth+2*diffMargin-boxWallThickness;
        translate([boxWallThickness,-2*diffMargin,
                   boxSizeHeight-coverThickness+d/2])
            coverCutCylinder(d,h);
        translate([boxSizeDepth-boxWallThickness,
                   -2*diffMargin,
                   boxSizeHeight-coverThickness+d/2])
            coverCutCylinder(d,h);
    }
    boxText();
}

module boxText(){
    // Frente e Fundo
    if(len(TextFront) > 0) translate([1,0,5]) CreateText(TextFront,boxSizeHeight/3,90,0,0);
    if(len(TextBack) > 0)
        translate([boxSizeDepth,boxSizeWidth,6])
            CreateText(TextBack,boxSizeHeight/3,90,0,180);
    // Lateral
    yOffset = 1;
    lateralFont = LateralFontSize > 0? LateralFontSize:(boxSizeHeight/2)-2;
    if(len(TextLateral1) > 0 && len(TextLateral2) > 0) {
        translate([0,boxSizeWidth-yOffset,boxSizeHeight/2])
            CreateText(TextLateral1,lateralFont,90,0,-90);
        translate([boxSizeDepth,yOffset,boxSizeHeight/2])
            CreateText(TextLateral1,lateralFont,90,0,90);
    }
    if(len(TextLateral1) > 0 && len(TextLateral2) == 0) {
        translate([0,boxSizeWidth-yOffset,boxSizeHeight/3])
            CreateText(TextLateral1,lateralFont,90,0,-90);
        translate([boxSizeDepth,0,boxSizeHeight/3])
            CreateText(TextLateral1,lateralFont,90,0,90);
    }
    if(len(TextLateral2) > 0){
        translate([0,boxSizeWidth-yOffset,1])
            CreateText(TextLateral2,lateralFont,90,0,-90);
        translate([boxSizeDepth,yOffset,1])
            CreateText(TextLateral2,lateralFont,90,0,90);
    }

}
module cover(){
    bwt = boxWallThickness;
    h=boxSizeWidth-bwt-printerErrorMargin;
    x=boxSizeDepth-bwt*2-printerErrorMargin;
    translate([bwt+0,0,0]){
        cube([x,
              h,
              coverThickness]);
        d=coverThickness*2/3;
        translate([0,-2*diffMargin,d/2])
            coverCutCylinder(d,h);
        translate([boxSizeDepth-bwt*2-printerErrorMargin,
                   -2*diffMargin,d/2])
            coverCutCylinder(d,h);
    }
    size = x/2;
    if(len(TextCover2) > 0){
        translate([x-2,1,coverThickness])
            CreateText(TextCover2,(size/2),0,0,90);
        translate([x/2-2,1,coverThickness])
            CreateText(TextCover1,(size/2),0,0,90);
    }else{
         translate([2*x/3,1,coverThickness])
            CreateText(TextCover1,(size/2),0,0,90);
    }
}
/* Aux Functions */
module coverCutCylinder(d,h){
    rotate(a=[-90,0,0])
        cylinder(d=d,
                 h=h);
}
module CreateText(Text, Size, RotX, RoY, RotZ){  
  if (!debug)
    color("blue")
      rotate(a=[RotX, RoY, RotZ])
          linear_extrude(height=TextHeight)
              text(Text,Size);
}

module batteryHolder(){
  // AAA box 16.58x58.05x13.59
  w = 16.58;
  d = 58.05;
  h = 13.59;
  
  // how wide? 17.12 + wall
  x = boxSizeDepth*.5;
  y = (boxWallThickness + d * .5) + 50 ;
  z = boxWallThickness + h * .5;
  translate([x,52,z]) color("blue") cube([w,d,h], center=true);
  }