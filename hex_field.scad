// parametric hex field by Vilem Marsik
// GPLv3
// All hexes are oriented in the direction of X axis

// hex width to length
function hex_a(d) = 2*d/sqrt(3);

// d=hex width, w=wall thickness (number substracted from d), h=height (on Z)
module hex_cell(d,w=0,h=1)
{
	cylinder(d=hex_a(d)-w,h=h,$fn=6);
}

// d=hex width, w=wall thickness (number substracted from d), h=height (on Z)
module hex_cell_half(d,w=0,h=1)
{
	d = (d-w)/2;
	a = hex_a(d);
	linear_extrude(height=h,center=false)
		polygon([[-a,0],[-a/2,d],[a/2,d],[a,0]]);
}

/*hex_cell_half(10,0,10);
mirror([0,1,0])
	hex_cell_half(10,0,10);*/

// num= number of hexes
// d=width of the row (for full hexes)
// w=wall thickness
// h=height (on Z)
// half: 0 for full hexes, 1 for bottom row, 2 for top row
module hex_row(num, d, w=0, h=1, half=0)
{
	if( num > 0 )	{
		for(i = [0:num-1])
		{
			translate([3*d*(i+1/3)/sqrt(3),0,0])
				if(half==1)
					hex_cell_half(d,w,h);
				else if(half==2)
					mirror([0,1,0]) hex_cell_half(d,w,h);
				else
					hex_cell(d,w,h);
		}
	}
}

// xnum: number of half-columns in X ( only xnum/2 hexes will be shown for ynum=1)
// ynum: number of half-rows in Y ( only ynum/2 hexes will be shown for xnum=1)
// d: smaller width of the hex, is in Y
// w: wall thickness
// h: height (i.e. Z-size)
// full: true to show half hexes at top/bottom
module hex_field(xnum, ynum, d, w=1, h=1, full=true)
{
	x1=floor((xnum+1)/2);
	x2=floor(xnum/2);
	xstep=d*sqrt(3)/2;
	if(full)
		translate([xstep,0,0])
			hex_row(x2, d, w, h, 1);
	for( i=[0:2:ynum-1] )
	{
		translate([0,d*(i+1)/2,0])
			hex_row(x1, d, w, h);
		if( i+1 < ynum )	{
			translate([xstep, d*(i+2)/2, 0])
				hex_row(x2, d, w, h);
		}
	}
	if( full )	{
		if( (ynum%2) == 0 )
			translate([0,d*(ynum+1)/2,0])
				hex_row(x1, d, w, h, 2);
		else
			translate([xstep, d*(ynum+1)/2, 0])
				hex_row(x2, d, w, h, 2);
	}
}

// xsize of xnum hexes in rows, hex width d
function hex_xsize(xnum,d) =
	0.25*hex_a(d)*(1+3*xnum);

// ysize of ynum hexes in columns, hex width d
function hex_ysize(ynum,d) =
		d*(.5+ynum/2);
	
// number of hexes fitting into xsize, d=hex widht, ceils if extra, floors otherwise
function hex_xnum(xsize,d,extra=false) =
	let(xnum=(4*xsize/(3*hex_a(d)))-1/3)
	extra ? ceil(xnum) : floor(xnum);

// number of hexes fitting into ysize, d=hex widht, ceils if extra, floors otherwise
function hex_ynum(ysize,d,extra=false) =
	let(ynum=2*ysize/d - 1)
	extra ? ceil(ynum) : floor(ynum);


/*
x=11;
y=20;
d=10;
hex_field(x,y,d,1,5);
%cube([hex_xsize(x,d),hex_ysize(y,d),1]);
*/

/*
x=73;
y=23;
d=10;
%cube([x,y,1]);
hex_field(hex_xnum(x,d), hex_ynum(y,d), d, 1, 5);
*/
