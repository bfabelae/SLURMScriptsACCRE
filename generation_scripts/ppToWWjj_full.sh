import model loop_sm-no_b_mass
define p = p b b~
define j = j b b~
define ell+ = e+ mu+ ta+
define ell- = e- mu- ta-
generate p p > ell+ vl w- j j
add process p p > ell- vl~ w+ j j 
output ppToWWjj_full -nojpeg
