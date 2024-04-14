## Install Ubuntu

- Disable secure boot in uefi and then boot Ubuntu usb drive and select `Install (safe graphics)`.
- Select to not install updates during the installation process, to avoid installing the nvidia drivers.
- After install, in the grub menu, select `Advanced` and then chose one of the `(safe graphics)` option from either the latest kernel or a known stable kernel version, such as `5.15.0.67` (version in the `ubuntu-20.04.6-desktop-amd64.iso`). Then select `Resume` to boot ubuntu in safe graphics.
- Alternatively, select the kernel without the `(safe graphics)`, then press the key `e` and add at the end of the `GRUB_CMDLINE_LINUX_DEFAULT` the argument `nomodeset`
- If grub does not show up, press `Ctrl + Alt + Del` or `Alt + Ptr Scn + B` to reboot and keep pressing the `ESC` key until it shows the `grub>` terminal. Then type `exit` and press enter to go to the grub menu.


## Update Ubuntu
```
sudo apt update
sudo apt dist-upgrade
snap-store --quit
snap refresh
```


## Install SSH
```
sudo apt install openssh-server
sudo ufw allow ssh
sudo systemctl status ssh
```


## ssh-copy-id

For remotely accessing the new formatted PC with `ssh` without having to retype the password every time, you can copy your ssh public key to the new PC.
```
ssh-copy-id user@host
```


## Install common apps
```
sudo apt install terminator -y
sudo apt install git -y
sudo apt install build-essential -y
sudo apt install synaptic -y
```


## Change quick_boot and quiet_boot to 0:
```
sudo nano /etc/grub.d/10_linux
```
```
quiet_boot="0"
quick_boot="0"
```


## Add save of grub boot order and fsck
```
sudo nano /etc/default/grub
```
```
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=10
GRUB_CMDLINE_LINUX_DEFAULT="fsck.mode=force fsck.repair=yes"
```
```
sudo update-grub
```


## Install other kernel versions if necessary

5.15.0-67 kernel version (default from `ubuntu-20.04.6-desktop-amd64.iso`)
```
sudo apt install linux-image-5.15.0-67-generic -y
sudo apt install linux-headers-5.15.0-67-generic -y
sudo apt install linux-modules-5.15.0-67-generic -y
sudo apt install linux-modules-extra-5.15.0-67-generic -y
sudo apt install linux-hwe-5.15-tools-5.15.0-67 -y
```


5.15.0-92 kernel version
```
sudo apt install linux-image-5.15.0-92-generic -y
sudo apt install linux-headers-5.15.0-92-generic -y
sudo apt install linux-modules-5.15.0-92-generic -y
sudo apt install linux-modules-extra-5.15.0-92-generic -y
sudo apt install linux-hwe-5.15-tools-5.15.0-92 -y
sudo apt install linux-modules-nvidia-535-5.15.0-92-generic -y
```


Latest kernel version
```
sudo apt install linux-image-$(uname -r) -y
sudo apt install linux-headers-$(uname -r) -y
sudo apt install linux-modules-$(uname -r) -y
sudo apt install linux-modules-extra-$(uname -r) -y
sudo apt install linux-hwe-5.15-tools-$(uname -r | sed 's/-generic//') -y
sudo apt install linux-modules-nvidia-535-$(uname -r) -y
```


## 5.15 kernel sources and docs
```
sudo apt install linux-hwe-5.15-source-5.15.0 linux-doc -y
```


## nvidia driver
```
sudo apt install nvidia-driver-535 -y
```


## Reboot and select kernel version
- Reboot and then in grub, select Advanced and then choose the kernel version 5.15.0.92 or other stable kernel version.
- With the `GRUB_DEFAULT=saved` from above, it will remember the boot entry in the next boot.


## cuda

Check which cuda version your nvidia driver supports
```
nvidia-smi
```

Check you gpu settings and enable ECC
```
nvidia-settings
```


### Default cuda version (10.1)
```
sudo apt install nvidia-cuda-toolkit -y
```

### Other versions of cuda
- https://docs.nvidia.com/cuda/cuda-installation-guide-linux/#ubuntu
```
sudo apt install linux-headers-$(uname -r)
sudo apt-key del 7fa2af80
cd
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt install cuda-toolkit-11-8
sudo apt install nvidia-gds-11-8
sudo reboot
```

Add to `.bashrc`
```
export PATH=/usr/local/cuda-11.8/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

Check version of cuda:
```
nvcc --version
```


## Cleanup
```
sudo apt autopurge
sudo apt autoclean
sudo reboot
```


## Check RAM ECC

Check if your RAM ECC is working:
```
sudo lshw -class memory
sudo lshw -class memory | grep ecc
```

Expected output:
```
capabilities: ecc
configuration: errordetection=ecc
```

If you have ECC RAM, the `Total Width` should be greater than the `Data Width`:
```
sudo dmidecode --type memory
```


## Check fsck logs
```
journalctl -u systemd-fsck*
```


## Power button

- To disable the popup when clicking on the NUC power button:
```
gsettings set org.gnome.SessionManager logout-prompt false
gsettings set org.gnome.settings-daemon.plugins.power button-power 'shutdown'
```
