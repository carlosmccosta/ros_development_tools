# udev rules

[udev rules tutorial](http://hackaday.com/2009/09/18/how-to-write-udev-rules)

- Find unique info
  ```
  udevadm info -q all -n /dev/ttyUSB0
  udevadm info -a -p $(udevadm info -q path -n /dev/ttyUSB0)
  ```

- Add a rule to /etc/udev/rules.d/ with the name ending in .rules
  ```
  sudo nano /etc/udev/rules.d/device_name.rules
  ```

- Add the rule content
  ```
  SUBSYSTEM=="tty", ATTRS{idProduct}=="ffee", ATTRS{idVendor}=="04d8", ATTRS{serial}=="00010571", MODE:="0666", SYMLINK+="device_name"
  ```

- Restart udev and then replug the device
  ```
  sudo service udev restart
  sudo /etc/init.d/udev restart
  sudo udevadm control --reload-rules && udevadm trigger
  ```
