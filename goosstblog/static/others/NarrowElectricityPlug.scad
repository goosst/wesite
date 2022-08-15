      
depth = 25;
thickness=2; //thickness shell socket
topthickness=3; //thickness top part where pins enter
height=14; //outside height socket, perpendicular to holes
length=37; //outside length socket, in line with holes
height_end=5.7; //length outer part of plug

chassis_thickness=2;
chassis_extralength=12; //chassis length additional to socket
chassis_extrawidth=0; //extra border of chassis
chassis_pinguidelength=9;

chassis_thickness_drillguid=4;
chassis_extrawidth_drillguid=5; //extra border of chassis for drilling guide


pin_diameter=4.9; //diameter electrical pins
pin_guidancediam=6;
pin_guidancediam_toler=0.6;

pin_guidance=true;

// PART I: plug
difference(){
    
union(){  

//chassis for mounting
translate([0,-depth/2+chassis_thickness/2,0])
cube([length+2*chassis_extralength, chassis_thickness, height+chassis_extrawidth*2], center=true);

//outer shape socket
   hull() {
        cube([23.6, depth, height], center=true);
        cube([length, depth, height_end], center=true);
    }
}  

//cylinder cutouts for electrical / 230V pins
for (i=[-1:2:1])
{
    translate([9*i,0,0])
rotate([90,0,0])
if (pin_guidance==false)
{    
 cylinder(h=depth+2, d=pin_diameter, $fn=40,center=true); 
}
else
{
    cylinder(h=depth+2, d=pin_guidancediam+pin_guidancediam_toler, $fn=40,center=true); 
}

}  


//cylinder cutouts for chassis bolts
for (i=[-1:2:1])
{
    translate([(length/2+chassis_extralength*2/3)*i,0,0])
rotate([90,0,0])    
 cylinder(h=depth+2, d=4.9, $fn=40,center=true); 
}  

//cutout for hollow inside of plug
translate([0,topthickness,0])
   hull() {
        cube([23.6-thickness, depth, height-thickness], center=true);
        cube([length-thickness, depth, height_end-thickness], center=true);
    }

}

difference(){
    union(){ 
//inner fillup 1
translate([-6/2,-depth/2,-height/2])
cube([6,depth-6,height],center=false);
    
    //inner fillup 2
        innerpiece=height-6.5;
translate([-6/2,-depth/2,-innerpiece/2])
cube([6,depth-3.5,innerpiece],center=false);
        
   //inner fillup border
translate([-(length-15)/2,-depth/2,-height/2+1])
cube([length-15,depth-6-1.25,2.5],center=false);     
        
           //inner fillup border
translate([-(length-15)/2,-depth/2,+height/2-3.5])
cube([length-15,depth-6-1.25,2.5],center=false);    
        
    }
    
//inner cutout for screw
translate([0,depth/2,0])
rotate([90,0,0])
cylinder(h=depth+2, d=2.9, $fn=40,center=true); 
}




// PART II: plug - guide
translate([100,0,0])

difference(){
union(){    
//chassis for mounting
translate([0,-depth/2+chassis_thickness/2,0])
cube([length+2*chassis_extralength, chassis_thickness, height+chassis_extrawidth*2], center=true);

//cylinders for guiding pins
for (i=[-1:2:1])
{
    translate([9*i,-depth/2+chassis_pinguidelength/2,0])
rotate([90,0,0])    
 cylinder(h=chassis_pinguidelength, d=pin_guidancediam, $fn=40,center=true); 
}  

}

//cylinder cutouts for electrical / 230V pins
for (i=[-1:2:1])
{
    translate([9*i,0,0])
rotate([90,0,0])    
 cylinder(h=depth+2, d=pin_diameter, $fn=40,center=true); 
}  

//cylinder cutouts for chassis bolts
for (i=[-1:2:1])
{
    translate([(length/2+chassis_extralength*2/3)*i,0,0])
rotate([90,0,0])    
 cylinder(h=depth+2, d=4.9, $fn=40,center=true); 
}  
}



// PART III: drill - guide
translate([200,0,0])

difference(){
union(){    
//chassis for mounting
translate([0,-depth/2+chassis_thickness_drillguid/2,0])
cube([length+2*chassis_extralength, chassis_thickness_drillguid, height+chassis_extrawidth_drillguid*2], center=true);

//cylinders for guiding pins
for (i=[-1:2:1])
{
    translate([9*i,-depth/2+chassis_pinguidelength/2,0])
rotate([90,0,0])    
 cylinder(h=chassis_pinguidelength, d=pin_guidancediam, $fn=40,center=true); 
}  

//cylinders for guiding pins
for (i=[-1:2:1])
{
    translate([(length/2+chassis_extralength*2/3)*i,-depth/2+chassis_pinguidelength/2,0])
rotate([90,0,0])    
 cylinder(h=chassis_pinguidelength, d=pin_guidancediam, $fn=40,center=true); 
}

}

//cylinder cutouts for electrical / 230V pins
for (i=[-1:2:1])
{
    translate([9*i,0,0])
rotate([90,0,0])    
 cylinder(h=depth+2, d=pin_diameter, $fn=40,center=true); 
}  


  

//cylinder cutouts for chassis bolts
for (i=[-1:2:1])
{
    translate([(length/2+chassis_extralength*2/3)*i,0,0])
rotate([90,0,0])    
 cylinder(h=depth+2, d=4.9, $fn=40,center=true); 
}  
}