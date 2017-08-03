# VMD_h2ocosine

[VMD](http://www.ks.uiuc.edu/Research/vmd/) script to label water molecules with different colors according to their orientations. H2O molecules with H-atoms facing toward/against the nearest silica surface are colored by blue and red, respectively (aka H-down/H-up configuration). The depth of colour saturation is dependent on the value of cosine theta, where theta is the angle between H2O dipole vector and the outward surface normal. For example, the most red water molecule has theta = 0 degree, and the most blue water molecule has theta = 180 degree.

## Requirements

[VMD](http://www.ks.uiuc.edu/Research/vmd/) is required.

## Reading .xtc file and call "h2ocosine" procedure

cd into the repository, and run

```bash
vmd
```

In the Tk console, import the sample .xtc file by typing in

```bash
source loading.tcl
```

Wait until vmd finish loading all the frames. The following will call the "h2ocosine" procedure

```bash
source VMD_h2ocosine.tcl
```

## Use h2ocosine to color-index water molecules

h2ocosine will display waer molecules at selected time frame, defined regions, and desired orientations. The h2ocosine function looks like.

```bash
h2ocosine {frame_nu cos_lb cos_ub BD1 BD2}
```

Arguments:
- frame_nu is the frame number (integer)

- cos_lb and cos_ub are the lower and upper bound of absolute cosine theta values (non-neg float).

- BD1 and BD2 set the boundaries of displaying region (in angstrom) in the z-direction of the simulation box (float).

For example, in the Tk console, type in

```bash
h2ocosine 3 0 1 65 85
```

VMD will display H2O molecules in the frame #3, in the region from z = 6.5nm to 8.5 nm. In this example, H2O molecules at any orientation will be deiplayed, andcolor-indexed according to the value of cosine theta. The h2ocosine procedure also print the summary of the displayed H2O molecules in the Tk console. The following is an output for the above example.

```bash
Frame #: 3
Displayed H2O orientation (radian): 0.00 to 90.00  and 90.00 to 180.00 
Displayed H2O molecules number: 568
Red H2O molecules number: 276
Blue H2O molecules number: 292
Average Cosine: -0.007079

|cos|		Red		Blue
0.8-1.0		66		63
0.6-0.8		64		59
0.4-0.6		40		61
0.2-0.4		45		50
0.0-0.2		61		59
```

## License

VMD_h2ocosine

Copyright (C) 2016 Si-Han Chen
