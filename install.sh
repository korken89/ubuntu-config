#!/bin/bash

packages="\
    git \
    cmake \
    libclang-3.8-dev \
    minicom \
    wget \
    curl \
    ack-grep \
    rxvt-unicode-256color \
    libboost-all-dev \
    libgtest-dev \
    libgoogle-glog-dev \
    libeigen3-dev \
    libnlopt-dev
    libcv-dev \
    texlive-full \
    latexmk \
    evince \
    nautilus-dropbox \
    xclip \
    mercurial \
    okular \
    qt5-default \
    qt5-qmake \
    libqt5serialport5-dev
    qtcreator \
    fonts-powerline \
    fonts-font-awesome \
    fonts-inconsolata \
    zsh \
    tlp \
    xautolock \
    blueman \
    nitrogen \
    pavucontrol \
    xbacklight \
    scrot \
    gnome-themes-standard \
    adwaita-icon-theme-full \
    lxappearance \
    thunar \
    arandr \
    compton \
    gimp \
    inkscape \
    "
i3wmpkgs="\
    i3 \
    i3blocks \
    j4-dmenu-desktop
    "

atompkgs="\
atom-gdb-debugger \
build \
build-make \
busy \
clang-format \
git-plus \
highlight-line \
linter \
linter-clang \
monokai \
vim-mode-plus \
you-complete-me \
tabs-to-spaces \
language-vhdl \
vhdl-entity-converter \
"

#services="""
#sshd.socket
#libvirtd
#virtlogd.socket
#"""

removeables="\
    modemmanager \
    "
# Install some needed package
echo ""
echo Removing some software: $removeables
sleep 1
sudo apt remove --yes $removeables

echo ""
echo Upgrading...
sleep 1
sudo apt update
sudo apt dist-upgrade --yes

echo ""
echo Installing: $packages
sleep 1
sudo apt install --yes $packages

echo ""
echo Installing i3 Window Manager: $i3wmpkgs
sleep 1
sudo apt install --yes $i3wmpkgs

echo ""
echo Installing youtube-viewer
sleep 1
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt update
sudo apt install --yes youtube-viewer

echo ""
echo Installing Spotify
sleep 1
sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2C19886
sudo apt update
sudo apt install spotify-client

echo ""
echo Installing Telegram
sleep 1
sudo add-apt-repository ppa:atareao/telegram
sudo apt update
sudo apt install telegram

echo ""
echo Installing neovim
sleep 1
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install --yes neovim python-dev python-pip python3-dev python3-pip
sudo pip2 install --upgrade neovim
sudo pip3 install --upgrade neovim

echo ""
echo Installing ARM tools
sleep 1
sudo add-apt-repository ppa:team-gcc-arm-embedded/ppa
sudo apt update
sudo apt install --yes gcc-arm-embedded openocd dfu-util

echo ""
echo Installing Atom
sleep 1
sudo add-apt-repository ppa:webupd8team/atom
sudo apt update
sudo apt install --yes atom
apm install $atompkgs

echo ""
echo Installing ROS
sleep 1
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update
sudo apt install ros-kinetic-desktop-full python-catkin-tools ros-kinetic-default-cfg-fkie ros-kinetic-master-discovery-fkie ros-kinetic-master-sync-fkie ros-kinetic-multimaster-fkie ros-kinetic-multimaster-msgs-fkie ros-kinetic-node-manager-fkie

# echo Installing Atom packages
# sleep 1

# enable some stuff
# echo enabling: $services
# sudo systemctl enable $services
# sudo systemctl start $services

# fix udev rules

user=$(whoami)
echo ""
echo Setting groups for user: $user
sleep 1
# set some groups for manjaro and arch
sudo usermod -aG dialout $user

# Fix ltu printer system
# echo ""
# echo Fixing LTU printers...
# sleep 1
# sudo sh -c 'echo "ServerName IPP.LTU.SE" > /etc/cups/client.conf'

# Copying udev rules
echo ""
echo Copying udev rules...
sleep 1
sudo cp ./udev_rules/* /etc/udev/rules.d/
sudo udevadm control --reload

# Fix vim settings
echo ""
echo Fixing some nvim configs...
sleep 1
git clone https://github.com/korken89/nvim.git ~/.config/nvim
nvim -c PlugInstall

echo ""
echo Installing oh-my-zsh + extras
sleep 1
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sudo wget https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font -P /usr/lib/urxvt/perl
mkdir -p ~/.fonts
wget https://github.com/powerline/fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf -P ~/fonts

# Fix config files
echo ""
echo Fixing some configs...
sleep 1

mkdir -p ~/.i3
mkdir -p ~/.config/dunst
ln -sf "$(pwd)/i3_config" ~/.i3/config
ln -sf "$(pwd)/i3-battery.py" ~/.i3/i3-battery.py
ln -sf "$(pwd)/i3blocks.conf" ~/.i3/i3blocks.conf
ln -sf "$(pwd)/rc_additions" ~/.rc_additions
ln -sf "$(pwd)/aliases" ~/.aliases
ln -sf "$(pwd)/zshrc" ~/.zshrc
ln -sf "$(pwd)/agnoster_btf.zsh-theme" ~/.oh-my-zsh/themes
ln -sf "$(pwd)/Xresources" ~/.Xresources
ln -sf "$(pwd)/dunstrc" ~/.config/dunst/dunstrc
ln -sf "$(pwd)/latexmkrc" ~/.latexmkrc
ln -sf "$(pwd)/ymusic.sh" ~/.ymusic.sh
ln -sf "$(pwd)/atom-config.cson" ~/.atom/config.cson
sudo ln -sf "$(pwd)/lock.sh" /usr/bin/pixellock
sudo ln -sf "$(pwd)/i3exit" /usr/bin/i3exit
ln -sf "$(pwd)/gdbinit" ~/.gdbinit
sudo ln -sf "$(pwd)/20-intel.conf" /usr/share/X11/xorg.conf.d/20-intel.conf
echo "[[ -f '$(pwd)/rc_additions' ]] && source $(pwd)/rc_additions " >> ~/.bashrc
echo "[[ -f '$(pwd)/aliases' ]] && source $(pwd)/aliases " >> ~/.bashrc

