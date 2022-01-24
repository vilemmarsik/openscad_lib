/*
si=[170,55,11];
re=20;
wt=2;
bt=1;
cover_h=5;
epsilon=.3;
//set(si,re,wt,bt,cover_h);
//set_cut(si,re,wt,bt,cover_h);
//set_print(si,re,wt,bt,cover_h);
top(si,re,wt,bt,cover_h)
	translate([0,0,-bt-1])
		mirror([1,0,0])
		linear_extrude(1.5)
			text("Ahoj",halign="center",valign="center");
*/

module box_quarter(si,re,wt)	{
	hull()
		for(x=[-si[0]/2+re,si[0]/2-re])
			for(y=[-si[1]/2+re,si[1]/2-re])
				translate([x,y,0])
					cylinder(r=re+wt,h=si[2]);
}

module box_half(si,re,wt,bt)	{
	difference()	{
		translate([0,0,-bt])
			box_quarter([si[0],si[1],si[2]+bt],re,wt);
		box_quarter([si[0],si[1],si[2]+1],re,0);
	}
}

module box_bottom(si,re,wt,bh)	{
	box_half(si,re,wt,bt);
}
module box_top(si,re,wt,bt,cover_h)	{
	dw=2*wt+epsilon;
	difference()	{
		box_half([si[0]+dw,si[1]+dw,cover_h],re+wt,wt,bt);
		children();
	}
}
module box_set(si,re,wt,bt,cover_h)	{
	box_bottom(si,re,wt,bt);
	translate([0,0,si[2]+epsilon])
		rotate([180,0,0])
			box_top(si,re,wt,bt,cover_h)
				children();
}
module box_set_cut(si,re,wt,bt,cover_h)	{
	difference()	{
		box_set(si,re,wt,bt,cover_h)
			children();
		translate([0,0,-bt-1])
			rotate(-90)
				cube(1000);
	}
}
module box_set_print(si,re,wt,bt,cover_h)	{
	translate([0,0,bt])
		box_bottom(si,re,wt,bt);
	translate([0,si[1]+3*wt+epsilon,bt])
			box_top(si,re,wt,bt,cover_h)
				children();
}
