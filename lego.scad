// fork of https://www.thingiverse.com/thing:5699 by Vilem Marsik
// http://creativecommons.org/licenses/by/3.0/

//knob_diameter=4.8;		//knobs on top of blocks
knob_diameter=4.8;	//knobs on top of blocks
knob_height=2;
knob_spacing=8.0;
wall_thickness=1.45;
roof_thickness=1.05;
block_height=9.5;
pin_diameter=3;		//pin for bottom blocks with width or length of 1
//post_diameter=6.5;
post_diameter=6.5;
reinforcing_width=1.5;
axle_spline_width=2.0;
axle_diameter=5;
cylinder_precision=0.1;
epsilon=0.01;


/*
translate([0,-20,0])
	lego_block(5,2,1,axle_hole=true, knobs=true);

lego_top(6,3);

translate([0,25,0])
	lego_bottom(2,2);
*/

module lego_top(length, width)
{
	lego_block(length,width,height=0,knobs=true);
}

module lego_bottom(length, width, height=1/3)
{
	lego_block(length, width, height, knobs=false);
}

function lego_xsize(length) = (length-1)*knob_spacing+knob_diameter+wall_thickness*2;
function lego_ysize(width) = (width-1)*knob_spacing+knob_diameter+wall_thickness*2;
function lego_zsize(height) = height*block_height;

module lego_block(length,width,height,knobs=true,axle_hole=false,reinforcement=true,center=false) {
	overall_length=lego_xsize(length);
	overall_width=lego_ysize(width);
	start=(knob_diameter/2+knob_spacing/2+wall_thickness);
	x0 = (center ? -overall_length/2 : 0);
	y0 = (center ? -overall_width/2 : 0);
	translate([x0,y0,0])
		union() {
			difference() {
				union() {
					cube([overall_length,overall_width,height*block_height]);
					if(knobs)
					{
						translate([knob_diameter/2+wall_thickness,knob_diameter/2+wall_thickness,0]) 
							for (ycount=[0:width-1])
								for (xcount=[0:length-1]) {
									translate([xcount*knob_spacing,ycount*knob_spacing,-epsilon])
										cylinder(r=knob_diameter/2,h=block_height*height+knob_height+epsilon,$fs=cylinder_precision);
								}
					}
				}
				translate([wall_thickness,wall_thickness,-roof_thickness]) cube([overall_length-wall_thickness*2,overall_width-wall_thickness*2,block_height*height]);
				if (axle_hole==true)
					if (width>1 && length>1) for (ycount=[1:width-1])
						for (xcount=[1:length-1])
							translate([(xcount-1)*knob_spacing+start,(ycount-1)*knob_spacing+start,-block_height/2])  axle(height+1);
			}
	
			if (reinforcement==true && width>1 && length>1)
				difference() {
					for (ycount=[1:width-1])
						for (xcount=[1:length-1])
							translate([(xcount-1)*knob_spacing+start,(ycount-1)*knob_spacing+start,0]) reinforcement(height-epsilon);
					for (ycount=[1:width-1])
						for (xcount=[1:length-1])
							translate([(xcount-1)*knob_spacing+start,(ycount-1)*knob_spacing+start,-0.5]) cylinder(r=post_diameter/2-0.1, h=height*block_height+0.5-epsilon, $fs=cylinder_precision);
				}
	
			if (width>1 && length>1) for (ycount=[1:width-1])
				for (xcount=[1:length-1])
					translate([(xcount-1)*knob_spacing+start,(ycount-1)*knob_spacing+start,0]) post(height-epsilon,axle_hole);
	
			if (width==1 && length!=1)
				for (xcount=[1:length-1])
					translate([(xcount-1)*knob_spacing+start,overall_width/2,0]) cylinder(r=pin_diameter/2,h=block_height*height-epsilon,$fs=cylinder_precision);
	
			if (length==1 && width!=1)
				for (ycount=[1:width-1])
					translate([overall_length/2,(ycount-1)*knob_spacing+start,0]) cylinder(r=pin_diameter/2,h=block_height*height-epsilon,$fs=cylinder_precision);
		}
}

module post(height,axle_hole=false) {
	difference() {
		cylinder(r=post_diameter/2, h=height*block_height,$fs=cylinder_precision);
		if (axle_hole==true) {
			translate([0,0,-block_height/2])
				axle(height+1);
		} else {
			translate([0,0,-0.5])
				cylinder(r=knob_diameter/2, h=height*block_height+1,$fs=cylinder_precision);
		}
	}
}

module reinforcement(height) {
	union() {
		translate([0,0,height*block_height/2]) union() {
			cube([reinforcing_width,knob_spacing+knob_diameter+wall_thickness/2,height*block_height],center=true);
			rotate(v=[0,0,1],a=90) cube([reinforcing_width,knob_spacing+knob_diameter+wall_thickness/2,height*block_height], center=true);
		}
	}
}

module axle(height) {
	translate([0,0,height*block_height/2]) union() {
		cube([axle_diameter,axle_spline_width,height*block_height],center=true);
		cube([axle_spline_width,axle_diameter,height*block_height],center=true);
	}
}
			