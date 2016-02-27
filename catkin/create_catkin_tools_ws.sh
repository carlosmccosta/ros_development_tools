#!/bin/sh

echo "\n\n\n\n"
echo "####################################################################################################"
echo "##### Creating catkin workspace"
echo "####################################################################################################"


catkin_ws_dir=${1:-'catkin_ws'}

mkdir -p "$HOME/${catkin_ws_dir}/src"
cd "$HOME/${catkin_ws_dir}"
catkin config --init --isolate-devel --no-install --extend /opt/ros/jade

echo "\n\n"
echo "----------------------------------------------------------------------------------------------------"
echo ">>>>> Eclipse catkin_ws projects in ~/${catkin_ws_dir}/build"
echo "----------------------------------------------------------------------------------------------------"
