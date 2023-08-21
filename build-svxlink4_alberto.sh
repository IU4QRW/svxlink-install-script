#!/bin/bash -xe
# 21-07-2023 IU4QRW

# Aggiungo utente svxlink se non esiste
id -u svxlink &>/dev/null || useradd -m -p sad6nxuUx5Foc -s /bin/bash svxlink

apt-get update

apt-get --assume-yes upgrade

# Installing necessary packages
apt-get --assume-yes install libjsoncpp-dev libcurl4-nss-dev mtr-tiny openvpn dialog wget evtest vim screen cmake git g++ make libsigc++-2.0-dev libgsm1-dev libpopt-dev tcl8.6-dev libgcrypt20-dev libspeex-dev libasound2-dev alsa-utils libogg-dev libvorbis-dev vorbis-tools libopus-dev opus-tools rtl-sdr librtlsdr-dev ntp doxygen groff

# Make sure that we are in the home directory
cd

# Clone or update the repo
if [[ ! -d svxlink ]]; then
  #x alix git config --global http.sslVerify false
  git clone https://github.com/sm0svx/svxlink.git
  cd svxlink
else
  cd svxlink
  git fetch https://github.com/sm0svx/svxlink.git
  git checkout master
  git reset --hard origin/master
fi

# Checkout the wanted branch
if [ -n "reflector_tg" ]; then
  git checkout master
fi

# Create a build directory and build svxlink
cd /root/svxlink/src/
[[ -d build ]] && rm -rf build
mkdir build
cd build
cmake -DUSE_QT=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_SYSCONFDIR=/etc \
      -DCMAKE_INSTALL_LOCALSTATEDIR=/var ..
make -j5
make install
ldconfig

# Download and extract audio file
cd /usr/share/svxlink/sounds

wget https://github.com/sm0svx/svxlink-sounds-en_US-heather/releases/download/19.09/svxlink-sounds-en_US-heather-16k-19.09.tar.bz2 --no-check-certificate

tar xvjf svxlink-sounds-en_US-heather-16k-19.09.tar.bz2
#ln -s en_US-heather-16k/ en_US

# Download audio file it_IT
git clone https://github.com/IU4QRW/svxlink-sounds-it_IT.git
#ln -s svxlink-sounds-it_IT/ it_IT

ln -s svxlink-sounds-it_IT/ en_US

# Update with logrotare
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

