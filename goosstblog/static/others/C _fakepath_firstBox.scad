include <boxes.scad>

width_outer = 150;
length_outer = 120;
height_outer = 70;
wall_thickness=3;


handle_thickness=3;
handle_height=30;
handle_length=15;
thickness_plastic=2;

translate([0,5,-3.9]){
    
//sleeve to fix handle
translate([handle_length+wall_thickness+8,-handle_height/2,wall_thickness+10])
rotate([0,-90,0]){
difference(){
    translate([-thickness_plastic/2,-thickness_plastic/2,thickness_plastic/2])
cube([handle_thickness+thickness_plastic,handle_height+thickness_plastic,handle_length+thickness_plastic]); 
cube([handle_thickness,handle_height,handle_length]);    
}


translate([handle_length+wall_thickness-24,-handle_height/2+14,wall_thickness-2])
cube([handle_thickness+thickness_plastic,handle_height+thickness_plastic,handle_length+thickness_plastic]); 
}

translate([5,-18,7])
cube([width_outer,2,10]);

translate([5,16,7])
cube([width_outer,2,10]);

}



//myBox();

wiggle_room = 0.5;

//my_fn = 20;
my_fn=40;
//my_fn = 50;
//my_fn = 100;

//width_outer = 50;
//length_outer = 50;
//height_outer = 50;



//width_outer = 95;
//length_outer = 95;
//height_outer = 95;


//wall_thickness = (1/10) * width_outer;


width_inner = width_outer - (2 * wall_thickness);
length_inner = length_outer - (2 * wall_thickness);
height_inner = height_outer - (2 * wall_thickness);

lid_height = height_outer / 4;
lid_height_i = lid_height - wall_thickness;
lid_width_i = width_outer - wall_thickness;

lid_length_i = length_outer - wall_thickness;


module myBox() {
	translate(v=[0,0,height_outer/2]) difference() {
		cube([width_outer,length_outer,height_outer],center=true);
		cube([width_inner,length_inner,height_inner],center=true);
	}
}

module myBoxRounded() {
	translate(v=[0,0,height_outer/2]) difference() {
		roundedBox([width_outer,length_outer,height_outer],wall_thickness,center=true,$fn=my_fn);
		cube([width_inner,length_inner,height_inner],center=true);
	}
}


module boxNoLid() {
	difference() {
		myBox();
		myLidAtProperHeightWithWiggle();
	}
}

module boxNoLidRounded() {
	difference() {
		myBoxRounded();
		myLidAtProperHeightWithWiggle();
	}

}

module myLidAtProperHeight() {
	translate(v=[0,0,height_outer-lid_height]) myLidAtZero();
}

module myLidRoundedAtProperHeight() {
	translate(v=[0,0,height_outer-lid_height]) myRoundedLidAtZero();
}

module myLidAtProperHeightWithWiggle() {
	translate(v=[0,0,height_outer-lid_height]) myLidAtZeroWithWiggle();
}

module myRoundedLidAtZero() {
	difference() {
		difference() {
			roundedBox([width_outer,length_outer,lid_height*2],wall_thickness,false,$fn=my_fn,center=true);
			translate(v=[0,0,-lid_height]) cube([width_outer+1,length_outer+1,lid_height*2],center=true);
		}
		translate(v=[0,0,lid_height_i/2]) cube([lid_width_i,lid_length_i,lid_height_i],center=true);
	}
}

module myLidAtZero() {
	difference() {
		translate(v=[0,0,lid_height/2]) cube([width_outer,length_outer,lid_height],center=true);
		translate(v=[0,0,lid_height_i/2]) cube([lid_width_i,lid_length_i,lid_height_i],center=true);
	}
}

module myLidAtZeroWithWiggle() {
	difference() {
		translate(v=[0,0,lid_height/2]) cube([width_outer,length_outer,lid_height],center=true);
		translate(v=[0,0,lid_height_i/2]) cube([lid_width_i - wiggle_room,lid_length_i  - wiggle_room,lid_height_i],center=true);
	}
}

module boxPrintable() {
	translate(v=[(width_outer/2)+5,0,0]) boxNoLid();
	translate(v=[(width_outer/-2)-5,0,lid_height]) rotate([180,0,0]) myLidAtZero();
}

module boxOnlyRoundedPrintable() {
	boxNoLidRounded();
}

module boxOnlyPrintable() {
	boxNoLid();
}

module lidOnlyPrintable() {
	translate(v=[0,0,lid_height]) rotate([180,0,0]) myLidAtZero();
}

module lidOnlyRoundedPrintable() {
	translate(v=[0,0,lid_height]) rotate([180,0,0]) myRoundedLidAtZero();
}

module boxRoundedPrintable() {
	translate(v=[(width_outer/2)+5,0,0]) boxNoLidRounded();
	translate(v=[(width_outer/-2)-5,0,lid_height]) rotate([180,0,0]) myRoundedLidAtZero();
}

// Square box
//boxPrintable();
//boxOnlyPrintable();
//lidOnlyPrintable();

// Round box
boxRoundedPrintable();
//boxOnlyRoundedPrintable();
//lidOnlyRoundedPrintable();