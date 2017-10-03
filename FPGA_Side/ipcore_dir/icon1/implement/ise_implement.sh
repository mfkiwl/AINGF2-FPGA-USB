#!/bin/bash
################################################################################
##   ____  ____
##  /   /\/   /
## /___/  \  /    Vendor: Xilinx
## \   \   \/     Version : 1.06
##  \   \         Application : ICON v1.06_a Core
##  /   /         Filename : ise_implement.sh
## /___/   /\     
## \   \  /  \
##  \___\/\___\
##
##
## ise_implement.sh script 
## Generated by Xilinx ICON v1.06_a Core
##
#-----------------------------------------------------------------------------
# Script to synthesize and implement the RTL provided for the ICON core
#-----------------------------------------------------------------------------
#Exit on Error enabled.
set -o errexit

#Create results directory
rm -rf results
mkdir results
echo 'Running Coregen on VIO required for example design'
coregen -b chipscope_vio.xco -p coregen.cgp
# Check Results
if [ $? -gt 0 ] ; then 
echo An error occurred running coregen on chipscope_vio
echo FAIL
exit
fi

##-------------------------------Run Xst on Example design----------------------------
echo 'Running Xst on example design'
xst -ifn example_icon1.xst -ofn example_core.log -intstyle silent
# Check Results
if [ $? -gt 0 ] ; then 
echo An error occurred running XST on example_icon1
echo FAIL
exit
fi
cp chipscope_vio.ngc ./results
cp ../../icon1.ngc        ./results
cp example_icon1.ngc        ./results
cp chipscope_vio.ncf ./results
cp ../../icon1.ncf        ./results
cd ./results
##-------------------------------Run ngdbuild---------------------------------------
echo 'Running ngdbuild'
ngdbuild -uc ../../example_design/example_icon1.ucf -p xc3s400-pq208-4 -sd . example_icon1.ngc example_icon1.ngd
if [ $? -gt 0 ] ; then 
echo An error occurred running NGDBUILD on example_icon1 
echo FAIL
exit
fi
#end run ngdbuild section
##-------------------------------Run map-------------------------------------------
echo 'Running map'
map -w -p xc3s400-pq208-4 -o example_icon1.map.ncd example_icon1.ngd
if [ $? -gt 0 ] ; then 
echo An error occurred running MAP on example_icon1 
echo FAIL
exit
fi
##-------------------------------Run par-------------------------------------------
echo 'Running par'
par -w -ol high example_icon1.map.ncd example_icon1.ncd 
if [ $? -gt 0 ] ; then 
echo An error occurred running PAR on example_icon1 
echo FAIL
exit
fi
##---------------------------Report par results-------------------------------------
echo 'Running design through bitgen'
bitgen -d -g GWE_cycle:Done -g GTS_cycle:Done -g DriveDone:Yes -g StartupClk:Cclk -w example_icon1.ncd
if [ $? -gt 0 ] ; then 
echo An error occurred running BITGEN on example_icon1 
echo FAIL
exit
else
echo PASS
exit
fi
