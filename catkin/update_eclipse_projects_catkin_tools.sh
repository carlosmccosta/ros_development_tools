#!/bin/sh

catkin_ws_dir=${1:-'catkin_ws'}
build_type=${2:-'Release'} # Debug | Release | MinSizeRel | RelWithDebInfo
make_args=${3:-'-j8'}

echo "\n\n\n\n"
echo "####################################################################################################"
echo "##### Updating eclipse projects for [${catkin_ws_dir}] workspace using [${build_type}] configuration"
echo "####################################################################################################"


cd "$HOME/${catkin_ws_dir}"
catkin build --force-cmake --cmake-args -DCMAKE_BUILD_TYPE=${build_type} -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=${make_args} -G"Eclipse CDT4 - Unix Makefiles" # -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE
#catkin build --force-cmake --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8 -G"Eclipse CDT4 - Unix Makefiles"
#catkin_make --force-cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8


#cd ~/${catkin_ws_dir}/build
#cmake ../src/ -DCATKIN_DEVEL_SPACE=../devel -DCMAKE_INSTALL_PREFIX=../install -DCMAKE_BUILD_TYPE=${build_type} -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=${make_args} --force-cmake -G"Eclipse CDT4 - Unix Makefiles"


echo "\n\n"
echo "----------------------------------------------------------------------------------------------------"
echo ">>>>> Eclipse catkin_ws projects in $HOME/${catkin_ws_dir}/build"
echo "----------------------------------------------------------------------------------------------------"
