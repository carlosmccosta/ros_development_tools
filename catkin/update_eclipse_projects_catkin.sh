#!/bin/sh

echo "\n\n\n\n"
echo "####################################################################################################"
echo "##### Updating eclipse projects for catkin workspace"
echo "####################################################################################################"

cd ~/catkin_ws
catkin_make --force-cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8


echo "\n\n"
echo "----------------------------------------------------------------------------------------------------"
echo ">>>>> Eclipse catkin_ws projects in ~/catkin_ws/build"
echo "----------------------------------------------------------------------------------------------------"
