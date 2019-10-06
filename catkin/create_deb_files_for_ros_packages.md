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

Be aware that if you install pure CMake packages that were packaged as ROS packages and were installed into /opt/ros, they will override the system packages with the same name and version after you source the ROS setup.bash.

This approach can be useful for development purposes (project forks for example), in which the system installation of a package remains untouched (PCL for example) and a development version is built and prereleased as a ROS package for making it easier to install by end users.

However, this should be used with care, because if certain packages are expecting an oficial library .so and then at run time they find an .so that does not have a [compatible ABI](https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html) (because the ROS setup.bash changed the [LD_LIBRARY_PATH](http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html)) and the .so of the fork in /opt/ros was loaded instead of the one at /usr/lib), the program will terminate.

Check the tutorial at [ubuntu/libraries.md](../ubuntu/libraries.md) for more information.


### Uninstall .deb file

If later on you need to remove the .deb package, you can find its full name using:
```
apt-cache search partial-package-name
```
And remove it with:
```
sudo apt purge package-name
# or
sudo dpkg --purge package-name
```

Alternatively you can use the [Synaptic GUI](https://help.ubuntu.com/stable/ubuntu-help/addremove-install-synaptic.html.en).


### Update package list
```
rospack profile
```


### Notes about pre-release steps

For allowing the end users to know which commit was used to generate each .deb file, you should:
* Modify the [package.xml version tag](https://www.ros.org/reps/rep-0140.html#version) of each package following the [semantic versioning](https://semver.org/) approach
  * Check [this tutorial](http://wiki.ros.org/bloom/Tutorials/ReleaseCatkinPackage) if you want to release your package into the ROS build farm
* Create a changelog and commit any remaining changes to each package git repository
* Create a release tag in the git repository of each package


### Notes about compilation of .deb files with dependencies to other .deb files

For making sure that the packages for which you are generating .deb files are compiling and linking to the same library versions of other packages that have associated .deb files, you should follow this approach:
* Create a list with the packages for which you want to generate .deb files
* Check their dependencies using:
  * [rqt_dep](http://wiki.ros.org/rqt_dep)
  * [rosdep](https://docs.ros.org/independent/api/rosdep/html/commands.html):
    ```
    rosdep keys package_name_1 package_name_2 package_name_3
    ```
* Sort the packages in the proper order for following their compilation dependencies. For automating this step you can use [catkin tools](https://catkin-tools.readthedocs.io/en/latest/verbs/catkin_build.html#previewing-the-build):
    ```
    catkin build --dry-run package_name_1 package_name_2 package_name_3
    ```
* Create the rosdep .yaml file specifying the configurations for all the packages that you want to generate .deb files
* Add the .yaml file to the rosdep sources list (check instructions above)
* Then, do the following for each package:
  * cd package_folder
  * git checkout release_tag
  * source /opt/ros/$(rosversion -d)/setup.bash
  * rospack profile
  * Generate the .deb file using the instructions above
  * Install the .deb file using "sudo dpkg -i path_to_package.deb"
