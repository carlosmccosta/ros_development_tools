# Install Ubuntu with RAID 0 or 1 with two 1 TB SSD disks

- Start Ubuntu live usb in safe graphics.
- Select try Ubuntu.
- Open a terminal.


## Create partitions

- Use gparted or sgdisk to create the partitions on both disks.

- For RAID 0:
```
Disk 0
- EFI   - FAT32 -   2.00 GB -> nvme0n1p1
- ROOT0 - EXT4  - 300.00 GB -> nvme0n1p2
- HOME0 - EXT4  - 592.25 GB -> nvme0n1p3

Disk 1
- BOOT  - EXT4  -   2.00 GB -> nvme1n1p1
- ROOT1 - EXT4  - 300.00 GB -> nvme1n1p2
- HOME1 - EXT4  - 592.25 GB -> nvme1n1p3
```

- For RAID 1:
```
Disk 0
- EFI   - FAT32 -   2.00 GB -> nvme0n1p1
- ROOT0 - EXT4  - 300.00 GB -> nvme0n1p2
- HOME0 - EXT4  - 592.25 GB -> nvme0n1p3

Disk 1
- EFI   - FAT32 -   2.00 GB -> nvme1n1p1
- ROOT1 - EXT4  - 300.00 GB -> nvme1n1p2
- HOME1 - EXT4  - 592.25 GB -> nvme1n1p3
```


## Create raid array for the 2 root partitions

```
sudo -s
apt update
apt install mdadm
apt install grub-efi-amd64        # For RAID 1 only and with secure boot disabled
apt install grub-efi-amd64-signed # For RAID 1 only and with secure boot enabled
```

- For RAID 0 (`--level=0`):
    - Merges both disks into one.
    - Duplicates space and increases performance of read and write by around 2x.

```
mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/nvme0n1p2 /dev/nvme1n1p2
mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/nvme0n1p3 /dev/nvme1n1p3
mdadm --create /dev/md2 --level=0 --raid-devices=2 /dev/nvme0n1p4 /dev/nvme1n1p4
```

- For RAID 1 (`--level=1`):
    - Duplicates data across both disks, which allows a read performance of around 2x.
    - Increases reliability (if one disks fails the system will still boot and work using the other disk).

```
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/nvme0n1p2 /dev/nvme1n1p2
mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/nvme0n1p3 /dev/nvme1n1p3
mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/nvme0n1p4 /dev/nvme1n1p4
```

- Check RAID status, and wait while it is resyncing.
```
mdadm --detail /dev/md0
mdadm --detail /dev/md1
mdadm --detail /dev/md2
watch cat /proc/mdstat
```


## Install ubuntu

- Select `Something else`.
- Create the root and home partitions within `/dev/md0` and format them to EXT4 with the `/` and `/home` mount points.
- Configure the `/boot` in `nvme1n1p1` # For RAID 0 only.
- Configure the `EFI` in nvme0n1p1.
- Select the boot loader to use `Disk 0 (/dev/nvme0n1)`.
- After install, select `Continue testing`.


## Install mdadm into the md_root filesystem

- Check the state of md_root:
```
watch cat /proc/mdstat
```

If `State : clean, resyncing`, wait until resync is done (will change to `State : clean`)

- Check partitions:
```
lsblk
```

- Install mdadm:
```
sudo -s
mount /dev/md0p1 /mnt
mount /dev/nvme1n1p1 /mnt/boot # For RAID 0 only
mount -o bind /dev /mnt/dev
mount -o bind /dev/pts /mnt/dev/pts
mount -o bind /sys /mnt/sys
mount -o bind /proc /mnt/proc
cat /etc/resolv.conf >> /mnt/etc/resolv.conf
chroot /mnt
apt install mdadm
apt install grub-efi-amd64 # For RAID 1 only
apt install efibootmgr     # For RAID 1 only
```

- Add raid kernel module:
```
echo raid0 >> /etc/modules # For RAID 0 only
echo raid1 >> /etc/modules # For RAID 1 only
```

- Change quick_boot and quiet_boot to 0:
```
sudo nano /etc/grub.d/10_linux
```


- Add a premount wait script:
```
sudo nano /usr/share/initramfs-tools/scripts/local-premount/wait_for_mdadm
```

```
#!/bin/sh
echo
echo "Sleeping for 60 seconds while udevd and mdadm settle down"
sleep 60
echo "Done sleeping"
```

```
chmod a+x /usr/share/initramfs-tools/scripts/local-premount/wait_for_mdadm
```

- Wait until the disks finish resyncing:
```
watch cat /proc/mdstat
```

```
update-initramfs -u
update-grub
```


## Clone EFI partition (for RAID 1 only)

```
sudo dd if=/dev/nvme0n1p1 of=/dev/nvme1n1p1
```

- Take note of the path after FILE from the output from command below (default: \EFI\UBUNTU\SHIMX64.EFI):
```
sudo efibootmgr -v
```

- Paste the path from above into commands below to add the boot entries of both disks:
```
sudo efibootmgr -c -g -d nvme0n1p2 -L "Ubuntu - Disk 0" -l '\EFI\UBUNTU\SHIMX64.EFI'
sudo efibootmgr -c -g -d nvme1n1p2 -L "Ubuntu - Disk 1" -l '\EFI\UBUNTU\SHIMX64.EFI'
```

- Check that the EFI partition from both disks are in the boot list (to ensure that if one disk fails, it will boot from the other disk):
```
sudo efibootmgr -v
```

- Wait until the disks finish resyncing:
```
watch cat /proc/mdstat
```

- Reboot.

- Go into the BIOS / UEFI and check that both disks appear in the boot list.
- Make the first disk as the default boot.

- If the grub is updated, or any change is made to a EFI partition, it is necessary to clone the EFI partition from the first disk into the second disk again. For automating this, create the script:

```
sudo nano /etc/grub.d/90_efi_dd
#!/bin/sh
sudo dd if=/dev/nvme0n1p1 of=/dev/nvme1n1p1
if [ $? -eq 0 ]; then
    sudo sh -c "date > /var/log/journal/last_date_of_successful_efi_dd_from_nvme0n1p1_to_nvme1n1p1"
else
    sudo sh -c "date > /var/log/journal/last_date_of_failed_efi_dd_from_nvme0n1p1_to_nvme1n1p1"
fi
```


## Filesystem check at boot

https://www.baeldung.com/linux/force-file-system-check-every-boot

Edit the `/etc/fstab` file and make sure the partitions you want to check have the `fs_passno` with number 1 or 2.

Example (fs_passno is the last number):
```
UUID=2e5d42e1-c6d4-4120-b14d-dd712061f957 /               ext4    errors=remount-ro 0       1
```

Edit the parameter `GRUB_CMDLINE_LINUX_DEFAULT` in file `/etc/default/grub` and add at the end the fsck options:
```
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="fsck.mode=force fsck.repair=yes"
```

Then,
```
sudo update-grub
```

Alternative to using the grub parameters:
```
sudo tune2fs -c 1 /dev/md0p1
```

Check fsck logs with:
```
sudo more /run/initramfs/fsck.log
journalctl -u systemd-fsck*
```


## NVIDIA

If you boot with a black screen, you need to disable the loading of the nvidia driver at boot.

Press left shift during boot to go to the grub menu, then press `E` and add `nomodeset` in the line starting with `linux` at the end and before `$vt_handoff`
Then press `Ctrl+X` to proceed with the boot without the loading of the nvidia driver.

Switch to a terminal, `Ctrl + Alt + F1`, then remove the nvidia drivers installed by default with:

```
sudo apt-get --purge remove cuda-* nvidia-* gds-tools-* libcublas-* libcufft-* libcufile-* libcurand-* libcusolver-* libcusparse-* libnpp-* libnvidia-* libnvjitlink-* libnvjpeg-* nsight* nvidia-* libnvidia-* libcudnn8*
sudo apt-get --purge remove "*cublas*" "*cufft*" "*curand*" "*cusolver*" "*cusparse*" "*npp*" "*nvjpeg*" "cuda*" "nsight*"
sudo apt-get autoremove
sudo apt-get autoclean
sudo rm -rf /usr/local/cuda*
sudo dpkg -r cuda
sudo dpkg -r $(dpkg -l | grep '^ii  cudnn' | awk '{print $2}')
```

After reboot, install the latest supported nvidia driver:
```
sudo apt install linux-modules-nvidia-535-$(uname -r) -y
sudo apt install nvidia-driver-535 -y
sudo reboot
```

For installing CUDA:
- Add the nvidia PPA:
    - https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#network-repo-installation-for-ubuntu
- Check the maximum cuda toolkit version supported by the driver using:
    - `nvidia-smi`
- Then, install the version of the cuda toolkit you need, for example:
    - `sudo apt install cuda-toolkit-11-8`


## Power button

- To disable the popup when clicking on the NUC power button:
```
gsettings set org.gnome.SessionManager logout-prompt false
gsettings set org.gnome.settings-daemon.plugins.power button-power 'shutdown'
```


## More information

- https://askubuntu.com/questions/660023/how-to-install-ubuntu-14-04-16-04-64-bit-with-a-dual-boot-raid-1-partition-on-an
- https://askubuntu.com/questions/1299978/install-ubuntu-20-04-desktop-with-raid-1-and-lvm-on-machine-with-uefi-bios
- https://forum.level1techs.com/t/how-to-install-ubuntu-20-04-to-linux-me-raid/154105
- https://gist.github.com/umpirsky/6ee1f870e759815333c8
- https://raid.wiki.kernel.org/index.php/Why_RAID%3F#Swapping_on_RAID
- https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm
