# Virtual monitor for Ubuntu using nvidia GPU

For running a headless server without a monitor connected, it is necessary to enable a virtual monitor (otherwise the monitor will be all black in the remote desktop window).


## Disable wayland

- Uncomment `WaylandEnable=false` in file `/etc/gdm3/custom.conf`
- Reboot


## Create a new xorg.conf file

- Open `nvidia-settings` in a terminal
- Go to tab `X Server Display Configuration`
- Click in `Save to X Configuration file`


## Save the EDID file

- Connect monitor for which you want to capture EDID file
- Open `nvidia-settings` in a terminal
- Inside the GPU 0 tree, go to your monitor (for example `DP-0 - (BenQ LCD)`)
- Click in `Acquire EDID...`
- Save the file to folder `/etc/X11`


## Add custom EDID to xorg.conf

- Within `Section "Screen"` and above `SubSection     "Display"`, paste the options below, changing `U` to the port in which you had your monitor connected (for example, in the previous step, it was DP-0 -> U=0)

```
sudo nano /etc/X11/xorg.conf
```

```
Option         "ConnectedMonitor" "DFP-U"
Option         "CustomEDID" "DFP-U:/etc/X11/edid.bin"
Option         "IgnoreEDID" "false"
Option         "UseEDID" "true"
```


## Restart gdm from ssh

```
sudo systemctl restart gdm
```


## Disconnect the monitor for which you saved the EDID file

If you need to connect the same monitor in the future, you need to use the same `DP/HDMI` port.

If you need to connect the monitor in a different port or using a different monitor, you need to backup your `xorg.conf` and provide an empty or default `xorg.conf` without the custom `EDID` file.


## Manually turning on and off the virtual monitor

- For connecting a different monitor, disable the virtual monitor and restart X:

```
sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf_backup
sudo systemctl restart gdm
```

- When no monitor is connected, enable the virtual monitor and restart X:

```
sudo mv /etc/X11/xorg.conf_backup /etc/X11/xorg.conf
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

- https://nvidia.custhelp.com/app/answers/detail/a_id/3571/~/managing-a-display-edid-on-linux
- https://kodi.wiki/view/Archive:Creating_and_using_edid.bin_via_xorg.conf
- https://download.nvidia.com/XFree86/Linux-x86_64/460.67/README/xconfigoptions.html
- https://unix.stackexchange.com/questions/559918/how-to-add-virtual-monitor-with-nvidia-proprietary-driver
- https://superuser.com/questions/1278256/x-server-on-nvidia-card-with-no-screen
