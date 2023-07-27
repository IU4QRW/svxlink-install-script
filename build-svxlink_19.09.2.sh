#!/bin/bash -xe
# 21-07-2023 IU4QRW

# Aggiungo utente svxlink se non esiste
id -u svxlink &>/dev/null || useradd useradd -r -g daemon svxlink

# Installing necessary packages
apt-get update

apt-get --assume-yes upgrade


#NECESSARI
#libsigc++-2.0-dev 
#libgsm1-dev
#libpopt-dev 
#libgcrypt20-dev

#RACCOMANDATI
#libasound2-dev
#libspeex-dev
#opus-tools

#OPTIONAL
#rtl-sdr 
#doxygen
#groff

#VARI
#libjsoncpp-dev
#libcurl4-nss-dev
#mtr-tiny
#openvpn 
#dialog 
#wget 
#evtest 
#vim 
#screen
#cmake 
#git 
#g++ 
#make 
#tcl8.6-dev 
#alsa-utils 
#vorbis-tools 
#libopus-dev 
#librtlsdr-dev 
#ntp
apt-get --assume-yes install libjsoncpp-dev libcurl4-nss-dev mtr-tiny openvpn dialog wget evtest vim screen cmake git g++ make libsigc++-2.0-dev libgsm1-dev libpopt-dev tcl8.6-dev libgcrypt20-dev libspeex-dev libasound2-dev alsa-utils vorbis-tools libopus-dev opus-tools rtl-sdr librtlsdr-dev ntp doxygen groff

# Assicuriamoci di essere nella directory home
cd

# Download e decompressione della release
wget https://github.com/sm0svx/svxlink/archive/refs/tags/19.09.2.tar.gz --no-check-certificate
tar xvzf svxlink-19.09.2.tar.gz

# Fare backup files installazione precedente se esiste
#
#
#

# Create a build directory and build svxlink
cd svxlink-19.09.2/src/
mkdir build
cd build
cmake -DUSE_QT=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_SYSCONFDIR=/etc \
      -DCMAKE_INSTALL_LOCALSTATEDIR=/var ..
make -j5
make doc
make install
ldconfig

# Download e estrazione audio file en_US
cd /usr/share/svxlink/sounds
wget https://github.com/sm0svx/svxlink-sounds-en_US-heather/releases/download/19.09/svxlink-sounds-en_US-heather-16k-19.09.tar.bz2 --no-check-certificate
tar xvjf svxlink-sounds-en_US-heather-16k-19.09.tar.bz2
ln -s en_US-heather-16k/ en_US

# Download audio file it_IT
git clone https://github.com/IU4QRW/svxlink-sounds-it_IT.git
ln -s svxlink-sounds-it_IT/ it_IT

# Aggiornamento via logrotare
cd
cat > /etc/logrotate.d/svxlink <<EOF
/var/log/svxlink {
    missingok
    notifempty
    daily
    create 0644 svxlink root
    postrotate
    killall -HUP svxlink
    endscript
}
EOF