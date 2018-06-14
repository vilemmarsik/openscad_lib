// under GPL3 by Vilem Marsik
module half_rounded_cube(xs,ys,zs,r=5)
{
	hull()	{
		translate([r,r,0]) cylinder(h=zs,r=r);
		translate([xs-r,r,0]) cylinder(h=zs,r=r);
		translate([r,ys-r,0]) cylinder(h=zs,r=r);
		translate([xs-r,ys-r,0]) cylinder(h=zs,r=r);
	}
}