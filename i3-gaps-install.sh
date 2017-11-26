#!/bin/bash
# Install i3-gaps on Ubuntu 16
set -e
set -x
sudo apt install --yes libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev dh-autoreconf

mkdir -p $HOME/.repos
cd $HOME/.repos

echo ""
echo Installing deps for i3: xcb-util-xrm
sleep 1
if cd xcb-util-xrm; then \
 git pull;
else
 git clone --recursive https://github.com/Airblader/xcb-util-xrm.git xcb-util-xrm; cd xcb-util-xrm;
fi

./autogen.sh --prefix=/usr
make
sudo make install

sudo ldconfig
sudo ldconfig -p

cd $HOME/.repos

echo ""
echo Installing i3-gaps
sleep 1
if cd i3-gaps; then
 git pull
else
 git clone https://www.github.com/Airblader/i3 i3-gaps; cd i3-gaps;
fi

autoreconf --force --install
rm -Rf build/
mkdir build
cd build/
 ../configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
which i3
ls -l /usr/bin/i3
