# Generation of .deb files for ROS packages

There are several ways to generate deb files for a ROS package:
* [Bloom](http://wiki.ros.org/bloom)
  * [https://answers.ros.org/question/173804/generate-deb-from-ros-package/?answer=173845#post-id-173845](https://answers.ros.org/question/173804/generate-deb-from-ros-package/?answer=173845#post-id-173845)
* [CheckInstall](https://wiki.debian.org/CheckInstall)
* [dpkg-buildpackage](http://manpages.ubuntu.com/manpages/precise/man1/dpkg-buildpackage.1.html)
* [CPack](https://cmake.org/cmake/help/v3.0/module/CPack.html)


## Bloom

Install Bloom
```
sudo apt-get install python-bloom
sudo apt-get install fakeroot
sudo apt-get install dpkg-dev debhelper
```

### Generate .deb file

* Setup the ROS environment variables by sourcing the setup.bash script from your catkin_ws
* cd into the src package folder (where the CMakeLists.txt and package.xml are located)
  ```
  cd package_src_folder
  ```
* Check if your package.xml dependencies are in the rosdep database using:
  ```
  rosdep update
  rosdep check --from-paths . --ignore-src --rosdistro="$(rosversion -d)"
  ```
  You can also use:
  ```
  rosdep db | grep package_name
  ```
* Generate .deb file with [-O2 optimizations](http://wiki.ros.org/bloom/Tutorials/ChangeBuildFlags)
  ```
  bloom-generate rosdebian --ros-distro $(rosversion -d)
  fakeroot debian/rules binary
  ```

* The deb file will be added to the package parent directory


### Install .deb file
```
sudo dpkg -i path_to_package.deb
```
