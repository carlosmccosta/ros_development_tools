# Virtual monitor for Ubuntu

For running a headless server without a monitor connected, it is necessary to enable a virtual monitor (otherwise the monitor will be all black in the remote desktop window).


## Disable wayland

- Uncomment `WaylandEnable=false` in file `/etc/gdm3/custom.conf`
- Reboot


## Install the dummy monitor driver

```
sudo apt install xserver-xorg-video-dummy
```


## Generate the modeline for the virtual monitor

```
cvt [resolution_width] [resolution_height] [refresh_rate_hz]
```

For example:

```
cvt 1920 1080 60
```

Which outputs:

```
# 1920x1080 59.96 Hz (CVT 2.07M9) hsync: 67.16 kHz; pclk: 173.00 MHz
Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
```


## Create a new xorg.conf

```
sudo nano /etc/X11/xorg.conf
```

Paste the following, while updating with your respective `Modeline` information:

```
Section "Monitor"
  Identifier "Monitor0"
  HorizSync 28.0-80.0
  VertRefresh 48.0-75.0
  # 1920x1080 59.96 Hz (CVT 2.07M9) hsync: 67.16 kHz; pclk: 173.00 MHz
  Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
EndSection
Section "Device"
  Identifier "Card0"
  Option "VirtualHeads" "1"
  Driver "dummy"
  VideoRam 1024000
EndSection
Section "Screen"
  DefaultDepth 24
  Identifier "Screen0"
  Device "Card0"
  Monitor "Monitor0"
  SubSection "Display"
    Depth 24
    Modes "1920x1080_60.00"
  EndSubSection
EndSection
```


## Restart the X server

```
sudo systemctl restart gdm
```


## Manually turning on and off the virtual monitor

- When a monitor is connected, disable the virtual monitor and restart X:

```
sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf0
sudo systemctl restart gdm
```

- When no monitor is connected, enable the virtual monitor and restart X:

```
sudo mv /etc/X11/xorg.conf0 /etc/X11/xorg.conf
sudo systemctl restart gdm
```


## Starting GUI programs in ssh terminal

Before starting GUI programs remotely in a ssh command line, run (or add to .bashrc):

```
export DISPLAY=:0
xhost +local:
```


## Remote desktop GUIs

For connecting to the headless server, several GUI clients are available:

- [AnyDesk](https://anydesk.com/)
- [TeamViewer](https://www.teamviewer.com)
- [NoMachine](https://www.nomachine.com)
- [Remmina](https://remmina.org/)
    * Requires the activation of desktop sharing in the remote server
      * https://help.ubuntu.com/stable/ubuntu-help/sharing-desktop.html.en
    * Or the setup of a vncserver
      * https://help.ubuntu.com/community/VNC/Servers



## More information

- https://techoverflow.net/2019/02/23/how-to-run-x-server-using-xserver-xorg-video-dummy-driver-on-ubuntu
