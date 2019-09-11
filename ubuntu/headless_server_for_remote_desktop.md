# Remote desktop to Ubuntu headless server

For running a headless server without a monitor connected, it is necessary to enable a dummy monitor (otherwise the monitor will be all black in the remote desktop window).


## First, install the dummy monitor driver:

```
sudo apt install server-xorg-video-dummy-hwe-18.04
```


## Then, configure the associated X server file:

```
sudo nano /etc/X11/xorg.conf
```

Paste the following:
```
Section "Monitor"
  Identifier "Monitor0"
  HorizSync 28.0-80.0
  VertRefresh 48.0-75.0
  # https://arachnoid.com/modelines
  # 1920x1080 @ 60.00 Hz (GTF) hsync: 67.08 kHz; pclk: 172.80 MHz
  Modeline "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
EndSection
Section "Device"
  Identifier "Card0"
  #Option "NoDDC" "true"
  #Option "IgnoreEDID" "true"
  Option "VirtualHeads" "1"
  Driver "intel"
  VideoRam 512000
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

If you do not have an Intel CPU, change the [Driver "intel"] above appropriately (the dummy driver [Driver "dummy"] can be used, but it does not have GPU hardware acceleration)

If the dummy driver was not used, it is necessary to run the startup script below for setting up the virtual display:

```
cd
mkdir Scripts
cd Scripts
nano virtual_display.bash
```

Paste the following:
```
#!/usr/bin/env bash

xrandr -d :0 --output VIRTUAL1 --primary --auto
xrandr --newmode "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
xrandr --addmode VIRTUAL1 "1920x1080_60.00"
xrandr
```

Make the script executable:
```
chmod +x /home/$USER/Scripts/virtual_display.bash
```

Then, add it to the [startup applications](https://help.ubuntu.com/stable/ubuntu-help/startup-applications.html.en) and activate [automatic login](https://help.ubuntu.com/stable/ubuntu-help/user-autologin.html.en).



# Starting GUI programs in ssh terminal

Before starting GUI programs remotely in a ssh command line, run (or add to .bashrc):
```
export DISPLAY=:0
xhost +local:
```


# Remote desktop GUIs

For connecting to the headless server, several GUI clients are available:
* [TeamViewer](https://www.teamviewer.com)
* [NoMachine](https://www.nomachine.com)
* [Remmina](https://remmina.org/)
    * Requires the activation of desktop sharing in the remote server
      * https://help.ubuntu.com/stable/ubuntu-help/sharing-desktop.html.en
    * Or the setup of a vncserver
      * https://help.ubuntu.com/community/VNC/Servers



# Notes when using virtual and physical displays

The virtual display can be used alongside a physical monitor.
For making it easier to use, it might be best to go to the displays menu and [activate the mirror display mode](https://help.ubuntu.com/stable/ubuntu-help/display-dual-monitors.html).



# More info:
* https://techoverflow.net/2019/02/23/how-to-run-x-server-using-xserver-xorg-video-dummy-driver-on-ubuntu
* https://creechy.wordpress.com/2018/06/15/headless-ubuntu-18-04-with-vnc-access
