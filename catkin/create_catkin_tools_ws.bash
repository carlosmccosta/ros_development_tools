#!/bin/bash

catkin_ws_dir=${1:-'catkin_ws'}
ros_version=${2:-"$(rosversion -d)"}
extend_ws=${3:-"/opt/ros/$ros_version"}

echo -e "\n\n\n\n"
echo "####################################################################################################"
echo "##### Creating catkin workspace in [$catkin_ws_dir] using [$ros_version] and extending [$extend_ws]"
echo "####################################################################################################"

function AddProfile {
	catkin config --profile $1 -x _$1 --cmake-args -DCMAKE_BUILD_TYPE=$2
	catkin profile set $1
	catkin config --extend $3
	catkin config --append-args --cmake-args -DCMAKE_CXX_FLAGS="-Wall -W -Wno-unused-parameter -Werror=return-type"
}


mkdir -p "$HOME/${catkin_ws_dir}/src"
cd "$HOME/${catkin_ws_dir}"
source "${extend_ws}/setup.bash"

catkin config --init --no-install --extend ${extend_ws}
AddProfile debug Debug ${extend_ws}
AddProfile release_with_debug_info RelWithDebInfo ${extend_ws}
AddProfile release Release ${extend_ws}



echo -e "\n\n"
echo "----------------------------------------------------------------------------------------------------"
echo ">>>>> catkin workspace initialized"
echo "----------------------------------------------------------------------------------------------------"
