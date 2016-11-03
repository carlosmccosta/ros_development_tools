#!/bin/sh

build_dir=${1:-"$HOME/catkin_ws/build"}
source_dir=${2:-"$HOME/catkin_ws/src"}
build_type=${3:-'Release'} # Debug | Release | MinSizeRel | RelWithDebInfo
eclipse_version=${4:-'4.6'}
make_args=${5:-'-j8'}

cd "${build_dir}"
cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=${build_type} -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=${make_args} -DCMAKE_ECLIPSE_VERSION=${eclipse_version} "${source_dir}"
