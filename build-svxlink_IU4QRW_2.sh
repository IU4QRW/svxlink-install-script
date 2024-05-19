#!/bin/bash -xe
# 14-03-2024 IU4QRW

esegui() {
  exec=$1
  printf "\x1b[38;5;104m --> ${exec}\x1b[39m\n"
  eval ${exec}
}

scrivi () {
  say=$1
  printf "\x1b[38;5;220m${say}\x1b[38;5;255m\n"
}

MYPATH=${PWD}

scrivi "Aggiornamento"

esegui "apt-get --assume-yes update"

esegui "apt-get --assume-yes upgrade"

scrivi "Installazione prerequisiti"

esegui "apt-get --assume-yes install libjsoncpp-dev"

esegui "apt-get --assume-yes install libcurl4-nss-dev"

esegui "apt-get --assume-yes install mtr-tiny"

#esegui "apt-get --assume-yes install openvpn"

esegui "apt-get --assume-yes install dialog"

esegui "apt-get --assume-yes install wget" 
 
esegui "apt-get --assume-yes install evtest" 
 
esegui "apt-get --assume-yes install vim" 
 
esegui "apt-get --assume-yes install screen" 
 
esegui "apt-get --assume-yes install cmake" 
 
esegui "apt-get --assume-yes install git" 
 
esegui "apt-get --assume-yes install g++" 
 
esegui "apt-get --assume-yes install make" 
 
esegui "apt-get --assume-yes install libsigc++-2.0-dev" 
 
esegui "apt-get --assume-yes install libgsm1-dev" 
 
esegui "apt-get --assume-yes install libpopt-dev" 
 
esegui "apt-get --assume-yes install tcl8.6-dev" 
 
esegui "apt-get --assume-yes install libgcrypt20-dev" 
 
esegui "apt-get --assume-yes install libspeex-dev" 
 
esegui "apt-get --assume-yes install libasound2-dev" 
 
esegui "apt-get --assume-yes install alsa-utils" 
 
esegui "apt-get --assume-yes install libogg-dev" 
 
esegui "apt-get --assume-yes install libvorbis-dev" 
 
esegui "apt-get --assume-yes install vorbis-tools" 
 
esegui "apt-get --assume-yes install libopus-dev" 
 
esegui "apt-get --assume-yes install opus-tools" 
 
esegui "apt-get --assume-yes install rtl-sdr" 
 
esegui "apt-get --assume-yes install librtlsdr-dev" 
 
esegui "apt-get --assume-yes install ntp" 
 
esegui "apt-get --assume-yes install doxygen" 
 
esegui "apt-get --assume-yes install groff"

esegui "apt-get --assume-yes install wireguard" 

esegui "apt-get --assume-yes install swh-plugins tap-plugins ladspa-sdk"

esegui "apt-get --assume-yes install libgpiod-dev" 

esegui "apt-get --assume-yes install gpiod"

#scrivi "Disabling apache"

#esegui "systemctl disable apache2"

#esegui "systemctl disable apache-htcacheclean"

scrivi "Aggiunta utente svxlink e guppi"

esegui "groupadd svxlink"

esegui "useradd -g svxlink -d /etc/svxlink svxlink"

esegui "usermod -aG audio,nogroup,svxlink,plugdev svxlink"

#esegui "usermod -aG gpio svxlink"

if [[ ! -d svxlink ]]; then
  scrivi "Installazione e compilazione SvxLink"
  git clone https://github.com/sm0svx/svxlink.git
  cd svxlink
else
  scrivi "Aggiornamento e compilazione SvxLink"
  cd svxlink
  git fetch https://github.com/sm0svx/svxlink.git
  git checkout master
  git reset --hard origin/master
fi

cd /root/svxlink/src/
[[ -d build ]] && rm -rf build
mkdir build
cd build

scrivi "COMPILAZIONE Svxlink"

cmake -DUSE_QT=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_SYSCONFDIR=/etc \
      -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DWITH_SYSTEMD=ON ..
	  
make -j5

make doc

scrivi "INSTALLAZIONE Svxlink"

make install

ldconfig

cd ${MYPATH}




# Download and extract audio file
cd /usr/share/svxlink/sounds

#wget https://github.com/sm0svx/svxlink-sounds-en_US-heather/releases/download/19.09/svxlink-sounds-en_US-heather-16k-19.09.tar.bz2 --no-check-certificate

#tar xvjf svxlink-sounds-en_US-heather-16k-19.09.tar.bz2
#mv en_US-heather-16k en_US
#ln -s en_US-heather-16k/ en_US
#rm xvjf svxlink-sounds-en_US-heather-16k-19.09.tar.bz2

# Download audio file it_IT
git clone https://github.com/IU4QRW/svxlink-sounds-it_IT.git
mv svxlink-sounds-it_IT en_US
#ln -s svxlink-sounds-it_IT/ it_IT

#ln -s svxlink-sounds-it_IT/ en_US

# Update with logrotare
cat > /etc/logrotate.d/svxlink <<EOF
/var/log/svxlink.log {
    missingok
    notifempty
    daily
    create 0644 svxlink.log root
    postrotate
        killall -HUP svxlink
    endscript
}
EOF

