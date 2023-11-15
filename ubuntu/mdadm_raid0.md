# Install Ubuntu with RAID 0 with two 1 TB SSD disks

- Start Ubuntu live usb
- Select try ubuntu
- Open a terminal


## Create partitions

Use gparted or sgdisk to create the partitions on both discs

Disc 0
- EFI   - FAT32 -   2.00 GB
- ROOT0 - EXT4  - 822.25 GB
- SWAP          -  70.00 GB

Disc 1
- BOOT  - EXT4  -   2.00 GB
- ROOT1 - EXT4  - 822.25 GB
- SWAP          -  70.00 GB


## Create raid0 array for the 2 root partitions

```
sudo -s
apt update
apt install mdadm
mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/nvme0n1p2 /dev/nvme1n1p2
cat /proc/mdstat
```


## Install ubuntu

- Select `Something else`
- Create a partition within `/dev/md0` and format it to EXT4 with the root (/) mount point
- Configure the `EFI` and `swap` partitions
- Select the boot loader to use `disc 0 (/dev/nvme0n1)`
- After install, select `Continue testing`


## Install mdadm into the raid0 ubuntu filesystem

```
sudo -s
mount /dev/md0p1 /mnt
mount /dev/nvme1n1p1 /mnt/boot
mount -o bind /dev /mnt/dev
mount -o bind /dev/pts /mnt/dev/pts
mount -o bind /sys /mnt/sys
mount -o bind /proc /mnt/proc
cat /etc/resolv.conf >> /mnt/etc/resolv.conf
chroot /mnt
apt install mdadm
echo raid0 >> /etc/modules
update-initramfs -u
update-grub
```


## Filesystem check at boot

For forcing the EXT4 filesystem check at every boot:

```
sudo tune2fs -c 1 /dev/md0p1
```



## NVIDIA

If you boot with a black screen, you need to disable the loading of the nvidia driver at boot.

Press left shift during boot to go to the grub menu, then press `E` and add `nomodeset` in the line starting with `linux` at the end and before `$vt_handoff`
Then press `Ctrl+X` to proceed with the boot without the loading of the nvidia driver.

Switch to a terminal, `Ctrl + Alt + F1`, then remove the nvidia drivers installed by default with:

```
sudo apt purge nvidia*
```

After reboot, install the cuda metapackage to automatically install the cuda toolkit and the nvidia driver:
- https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#network-repo-installation-for-ubuntu



## More information

- https://askubuntu.com/questions/1299978/install-ubuntu-20-04-desktop-with-raid-1-and-lvm-on-machine-with-uefi-bios
- https://forum.level1techs.com/t/how-to-install-ubuntu-20-04-to-linux-me-raid/154105
- https://gist.github.com/umpirsky/6ee1f870e759815333c8
- https://raid.wiki.kernel.org/index.php/Why_RAID%3F#Swapping_on_RAID
- https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm
