#Load trajectories
mol new ini.gro type gro first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor 0
mol addfile 10frames.xtc type xtc first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor 0
menu tkcon on
