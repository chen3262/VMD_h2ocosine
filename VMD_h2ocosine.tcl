#
# This file is part of VMD_h2ocosine
# https://github.com/chen3262/VMD_h2ocosine
#
# Copyright (c) 2016 Si-Han Chen
#
# Program:
# 	This TCL procedure will display SOL molecules in each frame with different orientations, 
#	labeling by different colors. 
# 	1st argument: frame number
# 	2nd and 3rd arguments: the lower and upper bound of cosine theta values, where the theta 
#	is the angle between H2O dipole vector and the outward surface normal. 
# 	4th and 5th set the boundaries of displaying region of the simulation box
# History:
#	06.10.2016 Si-Han Chen first release
#
proc h2ocosine {frame_nu cos_lb cos_ub BD1 BD2} {
	set f_nu $frame_nu
	set atnu_sys [[atomselect top all] num];# total atom number in the trajectory/configuration file
	set atnu_sol [[atomselect top "resname SOL"] num];# tot SOL atom number
	set molnu_sol [expr $atnu_sol/3]
	set sol_on {};#declare and initialize a list to store the indice of selected H2O atoms
	set pi 3.1415926535897931
        set nu_red 0
        set nu_blue 0
	set av_cos 0
	set sol_08_1_p 0; set sol_08_1_n 0
        set sol_06_08_p 0; set sol_06_08_n 0
        set sol_04_06_p 0; set sol_04_06_n 0
        set sol_02_04_p 0; set sol_02_04_n 0
        set sol_0_02_p 0; set sol_0_02_n 0

	#Looping over all SOL atoms and calculate cosine of each H2O molecule
	for {set i 0} {$i < $molnu_sol} {incr i} {
		set ow [atomselect top "index [expr ($atnu_sys-$atnu_sol) + 3*$i + 0]" frame $f_nu ]
		set hw1 [atomselect top "index [expr ($atnu_sys-$atnu_sol) + 3*$i + 1]" frame $f_nu ]
		set hw2 [atomselect top "index [expr ($atnu_sys-$atnu_sol) + 3*$i + 2]" frame $f_nu ]
		set ow_x [$ow get x]
		set ow_y [$ow get y]
		set ow_z [$ow get z]
        	set hw1_x [$hw1 get x]
        	set hw1_y [$hw1 get y]
        	set hw1_z [$hw1 get z]
        	set hw2_x [$hw2 get x]
        	set hw2_y [$hw2 get y]
        	set hw2_z [$hw2 get z]
		array set norm {x 0 y 0 z 1}
		set dipole(x) [expr ($hw1_x+$hw2_x)/2 - $ow_x]
		set dipole(y) [expr ($hw1_y+$hw2_y)/2 - $ow_y]
		set dipole(z) [expr ($hw1_z+$hw2_z)/2 - $ow_z]
		set cosine [expr ( $norm(x)*$dipole(x)+$norm(y)*$dipole(y)+$norm(z)*$dipole(z) ) / ( sqrt($dipole(x)*$dipole(x)+$dipole(y)*$dipole(y)+$dipole(z)*$dipole(z))*(1) ) ]
		
		#For SOL atoms in selected orientation window and box region, reset the color indices (Beta factor) as a fn of cosine values.
		if { (abs($cosine) >= $cos_lb) && (abs($cosine) <= $cos_ub) && ($ow_z>=$BD1) && ($ow_z<$BD2) } {
			#Create lists to store selected SOL atom indices,sol_on. The length = number of SOL atoms to be displayed.
			lappend sol_on [expr ($atnu_sys-$atnu_sol) + 3*$i + 0]
                        lappend sol_on [expr ($atnu_sys-$atnu_sol) + 3*$i + 1]
                        lappend sol_on [expr ($atnu_sys-$atnu_sol) + 3*$i + 2]
			set av_cos [expr $av_cos + $cosine];#sum over cosine of selected H2O molecule
			
			if { $cosine >=0 } {
				set nu_red [expr $nu_red +3]
				if { ($cosine>=0.8) && ($cosine<1) } {
					set sol_08_1_p [expr $sol_08_1_p+1]
					$ow set beta 0; $hw1 set beta 0; $hw2 set beta 0;
				} elseif { ($cosine>=0.6) && ($cosine<0.8) } {
					set sol_06_08_p [expr $sol_06_08_p+1]
					$ow set beta 0.05; $hw1 set beta 0.05; $hw2 set beta 0.05;
				} elseif { ($cosine>=0.4) && ($cosine<0.6) } {
					set sol_04_06_p [expr $sol_04_06_p+1]
                                        $ow set beta 0.1; $hw1 set beta 0.1; $hw2 set beta 0.1;
                                } elseif { ($cosine>=0.2) && ($cosine<0.4) } {
					set sol_02_04_p [expr $sol_02_04_p+1]
					$ow set beta 0.15; $hw1 set beta 0.15; $hw2 set beta 0.15;
                                } else {
					set sol_0_02_p [expr $sol_0_02_p+1]
					$ow set beta 0.3; $hw1 set beta 0.3; $hw2 set beta 0.3;
                                }
			} else {
				set nu_blue [expr $nu_blue + 3]
				if { ($cosine>=-0.2) && ($cosine<0) } {
                                        set sol_0_02_n [expr $sol_0_02_n+1]
					$ow set beta 0.3; $hw1 set beta 0.3; $hw2 set beta 0.3;
				} elseif { ($cosine>=-0.4) && ($cosine<-0.2) } {
                                        set sol_02_04_n [expr $sol_02_04_n+1]
					$ow set beta 0.35; $hw1 set beta 0.35; $hw2 set beta 0.35;
				} elseif { ($cosine>=-0.6) && ($cosine<-0.4) } {
                                        set sol_04_06_n [expr $sol_04_06_n+1]
                                        $ow set beta 0.4; $hw1 set beta 0.4; $hw2 set beta 0.4;
                                } elseif { ($cosine>=-0.8) && ($cosine<-0.6) } {
                                        set sol_06_08_n [expr $sol_06_08_n+1]
                                        $ow set beta 0.4; $hw1 set beta 0.4; $hw2 set beta 0.4;
                                } else {
					set sol_08_1_n [expr $sol_08_1_n+1]
                                        $ow set beta 0.5; $hw1 set beta 0.5; $hw2 set beta 0.5;
                                }
			}
		}
	}


	# Add a new representation to display H2O molecules fall between the lower and upper orientational angles.
        mol delrep 1 0
	mol delrep 1 0
		#Rep 1 - selecte atoms
        mol color Beta
        mol representation CPK 1.000000 0.300000 1.000000 3.000000
        mol selection index $sol_on
        mol material Opaque
        mol addrep 0    
		#Rep 2 - all atoms background
	mol color Name
	mol representation CPK 0.000000 0.300000 1.000000 3.000000
	mol selection all
	mol material Glass3
	mol addrep 0
        mol showrep 0 0 0 ;# hide representation 0 "all"
        mol showrep 0 1 1 ;# show representation 1 "selected H2O"
	mol showrep 0 2 1 ;# show representation 2 "all atoms background"
        animate goto $f_nu ;# show configurations at selected frame 
        display projection Orthographic
        display depthcue on
	#display resetview

	# Printing display information on the screen
	puts ""
        puts "Frame #: $f_nu"
        puts "Displayed H2O orientation (radian): [format {%0.2f} [expr acos($cos_ub)*360/(2*$pi)]] to [format {%0.2f} [expr acos($cos_lb)*360/(2*$pi)]]  and [format {%0.2f} [expr acos(-$cos_lb)*360/(2*$pi)]] to [format {%0.2f} [expr acos(-$cos_ub)*360/(2*$pi)]] "
        puts "Displayed H2O molecules number: [expr [llength $sol_on]/3]"
	puts "Red H2O molecules number: [expr $nu_red/3]"
	puts "Blue H2O molecules number: [expr $nu_blue/3]"
	puts "Average Cosine: [format {%0.6f} [expr $av_cos/([llength $sol_on]/3)]]"
	puts ""
	puts "|cos|		Red		Blue"
	puts "0.8-1.0		$sol_08_1_p		$sol_08_1_n"
	puts "0.6-0.8		$sol_06_08_p		$sol_06_08_n"
	puts "0.4-0.6		$sol_04_06_p		$sol_04_06_n"
	puts "0.2-0.4		$sol_02_04_p		$sol_02_04_n"
	puts "0.0-0.2		$sol_0_02_p		$sol_0_02_n"
	puts ""
}
