# Library paths

The paths that the dynamic linker searches are specifyed in the `/etc/ld.so.conf` file, which includes the configuration files present in the `/etc/ld.so.conf.d` directory.
The dynamic linker can also rely on paths specified in the [LD_LIBRARY_PATH](http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html) environment variable.

The .so shared libraries are selected according to the order of the files in `/etc/ld.so.conf`
After changing this file, it is necessary to run `sudo ldconfig` to rebuild the .so cache.

For checking what libraries are available to the dynamic linker, use:
```
sudo ldconfig -p
sudo ldconfig -v
```


# Dependencies

For checking which libraries are associated with a given binary or .so file, use:
```
ldd path_to_file
# or
readelf -d path_to_file
```

For checking the symbol table of a .so file, use:
```
readelf -Ws path_to_file | c++filt
# or
objdump -t path_to_file | c++filt
```
