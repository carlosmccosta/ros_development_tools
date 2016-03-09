#!/bin/sh

echo "\n\n\n\n"
echo "####################################################################################################"
echo "##### Creating catkin workspace"
echo "####################################################################################################"


catkin_ws_dir=${1:-'catkin_ws'}

mkdir -p "$HOME/${catkin_ws_dir}/src"
cd "$HOME/${catkin_ws_dir}"
catkin config --init --no-install --extend /opt/ros/jade
catkin config --profile debug -x _debug --cmake-args -DCMAKE_BUILD_TYPE=Debug
catkin config --profile release -x _release --cmake-args -DCMAKE_BUILD_TYPE=Release
catkin config --profile release_with_debug_info -x _release_with_debug_info --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo
catkin profile set debug
catkin config --append-args --cmake-args -DCMAKE_CXX_FLAGS="-Wall -W -Wno-unused-parameter"


echo "\n\n"
echo "----------------------------------------------------------------------------------------------------"
echo ">>>>> catkin workspace initilized"
echo "----------------------------------------------------------------------------------------------------"
