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
    youtube-dl \
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
    "
i3wmpkgs="\
    i3 \
    i3blocks \
    "

atompkgs="\
    atom-gdb-debugger \
    build\
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
echo Installing neovim
sleep 1
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install --yes neovim python-dev python-pip python3-dev python3-pip

# echo Installing Atom packages
# sleep 1
# apm install $atompkgs

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
# echo Fixing LTU printer...
# sleep 1
# sudo sh -c 'echo "ServerName IPP.LTU.SE" > /etc/cups/client.conf'

# Fix config files
echo ""
echo Fixing some configs...
sleep 1

if [ -f ~/.Xresources ]; then
    echo ""
    echo ".Xresources already exists, moved to .Xresources_old."
    mv ~/.Xresources ~/.Xresources_old
fi
mkdir -p ~/.i3
ln -sf "$(pwd)/i3_config" ~/.i3/config
ln -sf "$(pwd)/i3-battery.py" ~/.i3/i3-battery.py
ln -sf "$(pwd)/i3blocks.conf" ~/.i3/i3blocks.conf
ln -sf "$(pwd)/rc_additions" ~/.rc_additions
ln -sf "$(pwd)/aliases" ~/.aliases
ln -sf "$(pwd)/zshrc" ~/.zshrc
ln -sf "$(pwd)/agnoster_btf.zsh-theme" ~/.oh-my-zsh/themes
ln -sf "$(pwd)/Xresources" ~/.Xresources
ln -sf "$(pwd)/latexmkrc" ~/.latexmkrc
echo "[[ -f '$(pwd)/rc_additions' ]] && source $(pwd)/rc_additions " >> ~/.bashrc
echo "[[ -f '$(pwd)/aliases' ]] && source $(pwd)/aliases " >> ~/.bashrc
ln -sf "$(pwd)/ymusic.sh" ~/.ymusic.sh
ln -sf "$(pwd)/atom-config.cson" ~/.atom/config.cson
sudo ln -sf "$(pwd)/lock.sh" /usr/bin/pixellock
ln -sf "$(pwd)/gdbinit" ~/.gdbinit

# Copying udec rules
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
sudo pip2 install --upgrade neovim
sudo pip3 install --upgrade neovim
nvim -c PlugInstall

echo ""
echo Installing oh-my-zsh + extras
sleep 1
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sudo wget https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font -P /usr/lib/urxvt/perl
mkdir -p ~/.fonts
wget https://github.com/powerline/fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf -P ~/fonts

