#
# This file is part of VMD_h2ocosine
# https://github.com/chen3262/VMD_h2ocosine
#
# Copyright (c) 2016 Si-Han Chen
#
#
#Load trajectories
mol new ini.gro type gro first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor 0
mol addfile 10frames.xtc type xtc first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor 0
menu tkcon on
