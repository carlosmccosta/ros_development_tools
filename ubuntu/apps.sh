#!/bin/sh

echo "####################################################################################################"
echo "##### Installing packages"
echo "####################################################################################################"


echo "\n\n"
echo "------------------------------------------------"
echo ">>>>> Adding repositories"
echo "------------------------------------------------"

# >>>>> Programming
# +++ VCS
sudo add-apt-repository ppa:git-core/ppa -y # latest git
sudo add-apt-repository ppa:eugenesan/ppa -y # SmartGitHg
sudo add-apt-repository ppa:rabbitvcs/ppa -y # git and svn nautilus integration

sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y # g++ latest
sudo add-apt-repository ppa:webupd8team/java -y # Java Oracle
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y # best text editor
sudo add-apt-repository ppa:ubuntu-sdk-team/ppa -y # QT sdk
sudo add-apt-repository ppa:zarquon42/meshlab -y # latest meshlab
sudo add-apt-repository ppa:romain-janvier/cloudcompare -y # latest cloudcompare


# >>>>> Multimedia
sudo add-apt-repository ppa:nilarimogard/webupd8 -y # for pulseaudio-equalizer
sudo add-apt-repository ppa:kazam-team/stable-series -y # desktop recording
sudo add-apt-repository ppa:irie/blender -y # 3d modeling
sudo add-apt-repository ppa:inkscape.dev/stable -y
sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y
sudo add-apt-repository ppa:shutter/ppa -y # desktop screenshots
sudo sh -c "echo 'deb http://archive.canonical.com/ubuntu/ $(lsb_release -sc) partner' >> /etc/apt/sources.list.d/canonical_partner.list" # Skype
sudo add-apt-repository ppa:videolan/stable-daily -y # latest vlc
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y # qbittorrent client
sudo add-apt-repository ppa:deluge-team/ppa -y # delugue bit torrent client


# >>>>> Media players
sudo add-apt-repository ppa:banshee-team/ppa -y
sudo add-apt-repository ppa:nightingaleteam/nightingale-release -y
sudo add-apt-repository ppa:me-davidsansome/clementine -y


# >>>>> Text tools
sudo add-apt-repository ppa:blahota/texstudio -y
sudo add-apt-repository ppa:libreoffice/ppa -y # latest Libre Office
sudo add-apt-repository ppa:b-eltzner/qpdfview -y


# >>>>> OS tools
sudo add-apt-repository ppa:gnome-terminator -y
sudo add-apt-repository ppa:tualatrix/ppa -y # Ubuntu Tweak
sudo add-apt-repository ppa:linrunner/tlp -y # power management
sudo add-apt-repository ppa:atareao/nautilus-extensions -y # pdf tools
sudo add-apt-repository ppa:webupd8team/y-ppa-manager -y # graphical ppa management
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y # grub customizer
sudo add-apt-repository ppa:freefilesync/ffs -y # freefilesync
sudo add-apt-repository ppa:indicator-brightness/ppa -y
sudo add-apt-repository ppa:webupd8team/nemo -y


# >>>>> Dropbox
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sudo add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main" -y



echo "\n\n"
echo "------------------------------------------------"
echo ">>>>> Updating packages index"
echo "------------------------------------------------"

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y



echo "\n\n"
echo "------------------------------------------------"
echo ">>>>> Installing packages"
echo "------------------------------------------------"

# >>>>> Programming
sudo apt-get install build-essential -y

# +++ gcc | g++
sudo apt-get install gcc-5 g++-5 -y
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 70
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 70

# latest g++ requires latest gdb
sudo apt-get install gdb gdb-doc gdbserver -y
gdb --version | grep "7.11" > /dev/null
if [ $? -ne 0 ]
then
	sudo apt-get install libncurses5-dev -y
	sudo apt-get install texinfo -y
	mkdir -p ~/gdb
	cd ~/gdb
	wget http://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.gz
	tar xfv gdb-7.11.tar.gz
	cd gdb-7.11
	./configure --prefix=/usr
	make
	sudo make install
	cd ~/
	rm -rf ~/gdb
fi


sudo apt-get install cmake cmake-gui -y
sudo apt-get install ccache -y
sudo apt-get install colorgcc -y
sudo apt-get install oracle-java8-installer -y
sudo apt-get install sublime-text-installer -y
sudo apt-get install meshlab
sudo apt-get install cloudcompare


# +++ VCS
sudo apt-get install git -y
sudo apt-get install subversion -y
sudo apt-get install mercurial -y
sudo apt-get install meld -y
sudo apt-get install tortoisehg tortoisehg-nautilus -y
sudo apt-get install smartgithg -y
sudo apt-get install rabbit rabbitvcs-nautilus3 -y


# >>>>> Multimedia
sudo apt-get install skype -y
sudo apt-get install flashplugin-installer gsfonts-x11 -y
sudo apt-get install ubuntu-restricted-extras -y
sudo apt-get install libavformat-extra-54 libavcodec-extra-54 -y
sudo apt-get install libdvdread4 -y
sudo /usr/share/doc/libdvdread4/install-css.sh
sudo apt-get install vlc browser-plugin-vlc -y
sudo apt-get install totem-plugins-extra
sudo apt-get install kazam -y
sudo apt-get install shutter -y
sudo apt-get install inkscape -y
sudo apt-get install gimp gimp-data gimp-data-extras gimp-plugin-registry -y
sudo apt-get install blender -y


# >>>>> Media players
sudo apt-get install banshee -y
sudo apt-get install nightingale -y
sudo apt-get install clementine -y


# >>>>> Text tools
sudo apt-get install libreoffice -y
sudo apt-get install qpdfview -y
sudo apt-get install diffpdf -y
sudo apt-get install ibus-qt4 -y
sudo apt-get install texlive-full -y
sudo apt-get install texstudio -y


# >>>>> Dropbox
sudo apt-get install dropbox -y


# >>>>> OS tools
sudo apt-get install synaptic -y
sudo apt-get install terminator -y
sudo apt-get install nemo nemo-fileroller nemo-terminal nemo-media-columns nemo-gtkhash nemo-copypaste-images nemo-rabbitvcs nemo-compare nemo-seahorse nemo-audio-tab -y
sudo apt-get install ntp -y
sudo /etc/init.d/ntp reload
sudo apt-get install ubuntu-tweak -y
sudo apt-get install indicator-multiload -y
sudo apt-get install indicator-cpufreq -y
sudo apt-get install unity-tweak-tool gnome-tweak-tool -y
sudo apt-get install tlp tlp-rdw -y
sudo tlp start
sudo apt-get install compiz compiz-plugins compiz-plugins-default compizconfig-settings-manager -y
sudo apt-get install conky-all -y
sudo apt-get install gparted -y
sudo apt-get install filezilla -y
sudo apt-get install y-ppa-manager -y
sudo apt-get install --no-install-recommends gnome-panel -y # usage: gnome-desktop-item-edit --create-new ~/.local/share/applications/
sudo apt-get install systemtap -y
# sudo apt-get install nvidia-cuda-toolkit -y
sudo apt-get install grub-customizer -y
sudo apt-get install p7zip p7zip-full p7zip-rar -y
sudo apt-get install freefilesync -y
sudo apt-get install indicator-brightness -y
sudo apt-get install xbacklight -y # xbacklight -set 30
sudo apt-get install gconf-editor -y
sudo apt-get install dconf-tools -y
sudo apt-get install cpufrequtils -y
sudo apt-get install sysstat -y
sudo apt-get install htop -y
sudo apt-get install iotop -y
#sudo apt-get install monitorix -y
sudo apt-get install python-pip -y
#sudo pip install Glances

# +++ sound equalizer
sudo apt-get install pulseaudio-equalizer -y
mkdir -p ~/.pulse/presets

# +++ synaptics touchpad
sudo apt-get install gpointing-device-settings -y
#sudo apt-get install kde-config-touchpad -y


# >>>>> nautilus extensions
sudo apt-get install nautilus-actions -y
sudo apt-get install nautilus-admin -y
sudo apt-get install nautilus-columns -y
sudo apt-get install nautilus-compare -y
sudo apt-get install nautilus-filename-repairer -y
sudo apt-get install nautilus-gtkhash -y
sudo apt-get install nautilus-ideviceinfo -y
sudo apt-get install nautilus-image-converter -y
sudo apt-get install nautilus-image-manipulator -y
sudo apt-get install nautilus-image-tools -y
sudo apt-get install nautilus-open-terminal -y
sudo apt-get install nautilus-pdf-tools -y
sudo apt-get install nautilus-script-manager -y
sudo apt-get install nautilus-share -y
sudo apt-get install nautilus-shareftp -y
sudo apt-get install nautilus-wipe -y
sudo apt-get install seahorse-nautilus -y

# >>>>> Torrents
sudo apt-get install deluge -y
sudo apt-get install qbittorrent -y
