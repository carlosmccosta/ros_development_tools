#!/bin/sh

echo "\n\n\n\n"
echo "####################################################################################################"
echo "##### Updating eclipse projects for catkin workspace"
echo "####################################################################################################"


catkin_ws_dir=${1:-'catkin_ws'}
build_type=${2:-'Release'} # Debug | Release | MinSizeRel | RelWithDebInfo
make_args=${3:-'-j8'}


cd ~/${catkin_ws_dir}
catkin build --force-cmake --cmake-args -DCMAKE_BUILD_TYPE=${build_type} -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=${make_args} -G"Eclipse CDT4 - Unix Makefiles"
#catkin build --force-cmake --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8 -G"Eclipse CDT4 - Unix Makefiles"
#catkin_make --force-cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8


#cd ~/${catkin_ws_dir}/build
#cmake ../src/ -DCATKIN_DEVEL_SPACE=../devel -DCMAKE_INSTALL_PREFIX=../install -DCMAKE_BUILD_TYPE=${build_type} -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=${make_args} --force-cmake -G"Eclipse CDT4 - Unix Makefiles"


echo "\n\n"
echo "----------------------------------------------------------------------------------------------------"
echo ">>>>> Eclipse catkin_ws projects in ~/${catkin_ws_dir}/build"
echo "----------------------------------------------------------------------------------------------------"
