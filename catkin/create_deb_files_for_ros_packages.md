# Generation of .deb files for ROS packages

There are several ways to generate deb files for a ROS package:
* [bloom](http://wiki.ros.org/bloom)
  * [https://answers.ros.org/question/173804/generate-deb-from-ros-package/?answer=173845#post-id-173845](https://answers.ros.org/question/173804/generate-deb-from-ros-package/?answer=173845#post-id-173845)
* [CheckInstall](https://wiki.debian.org/CheckInstall)
* [dpkg-buildpackage](http://manpages.ubuntu.com/manpages/precise/man1/dpkg-buildpackage.1.html)
* [CPack](https://cmake.org/cmake/help/v3.0/module/CPack.html)


## Bloom

Install bloom:
```
sudo apt-get install python-bloom
sudo apt-get install fakeroot
sudo apt-get install dpkg-dev debhelper
```

* For public release using the ROS build farm, read [this tutorial](http://wiki.ros.org/bloom/Tutorials/FirstTimeRelease)

* For generating .deb files for packages that have dependencies to packages that are not on the official rosdep lists, read the [rosdep documentation](http://docs.ros.org/independent/api/rosdep/html/contributing_rules.html) and [this readme file](https://github.com/mikeferguson/buildbot-ros/blob/master/documentation/private_repositories.md), that overall state that you need to:
  * Create a yaml file (in the workspace containing the packages, for example) specifying the local packages. Example of yaml content:
    ```
    package_name:
        ubuntu: [ros-kinetic-package-name]
    ```
  * Create a file in the rosdep sources folder:
    ```
    sudo nano /etc/ros/rosdep/sources.list.d/10-local.list
    ```
    * Add to this file the absolute path of the .yaml file created earlier. Example:
      ```
      yaml file:///absolute_path_to_local_rosdep_file_list.yaml
      ```
  * Update the rosdep:
    ```
    rosdep update
    ```
  * Check if the new rosdep packages lists are being correctly found using:
    ```
    rosdep resolve package_name
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
* Generate the configuration files using:
  ```
  bloom-generate rosdebian --ros-distro $(rosversion -d)
  ```
* Generate .deb file with [-O2 optimizations](http://wiki.ros.org/bloom/Tutorials/ChangeBuildFlags)
  ```
  fakeroot debian/rules binary
  ```
  * For speeding up the compilation, you can specify how many CPU cores will be used by the make program, using:
    ```
    export DEB_BUILD_OPTIONS="parallel=`nproc`"
    ```
  * Then, instead of using the default rules script above, use:
    ```
    fakeroot debian/rules "binary --parallel"
    ```

* The deb file will be added to the package parent directory


### Install .deb file
```
sudo dpkg -i path_to_package.deb
```


### Update package list
```
rospack profile
```


### Notes

For making sure that the packages for which you are generating .deb files grab the the same library versions of other packages that have associated .deb files, you should follow this approach:
* Enumerate the packages that you want to generate .deb files
* Sort them in the proper order for following their compilation dependencies
* Create the rosdep yaml file specifying the configurations for all the packages that you want to generate .deb files
* Add the .yaml file to the rosdep sources list (check instructions above)
* Then, do the following for each package:
  * source /opt/ros/$(rosversion -d)/setup.bash
  * rospack profile
  * Generate the .deb file using the instructions above
  * Install the .deb file using "sudo dpkg -i path_to_package.deb"
