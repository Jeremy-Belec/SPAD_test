# project name
name Vines_parametrisation
# execution graph
job 1   -post { extract_vars "$nodedir" n1_dvs.out 1 }  -o n1_dvs "sde -l n1_dvs.cmd"
job 2 -d "1"  -post { extract_vars "$nodedir" n2_des.out 2 }  -o n2_des "sdevice pp2_des.cmd"
check sde_dvs.cmd 1685560032
check sde_dvs.bnd 1685558106
check sdevice_des.cmd 1686253461
check sdevice.par 1690474627
check global_tooldb 1665432052
check gtree.dat 1690474649
check ./Germanium.par 1663762607
check ./Silicon.par 1607965838
# included files
file sdevice.par included ./Germanium.par
file sdevice.par included ./Silicon.par
