ME=$(whoami)
HERE=$(pwd)

# Install information about the wifi-network
#cp /home/debian/bin/wpa.conf /etc/wpa_supplicant/wpa_supplicant.conf

# Sometimes files have the wrong group. Correct that here
echo "Correcting owners/permissions"
find / -group 116 -exec chown root:root {} \;
# -exec chmod 744 {} \;
chmod +r /etc/dpkg/dpkg.cfg.d/*
chmod +r /etc/apt/apt.conf.d/*

echo "Setting timezone..."
cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

echo "Regenerating locale..."
locale-gen "en_US.UTF-8"

# recreate ssh keys (call me paranoid)
echo "Regenerating SSH-keys..."
rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server

echo "Adding mountpoints to /etc/fstab"
fstab_appended=$(cat /etc/fstab |grep "boson" |wc -l)
if [ $fstab_appended==0 ]; then
  echo 'boson.lan:/srv/array1/backup    /mnt/backup nfs4 nouser,atime,rw,dev,exec,suid,noauto  0  0'  | tee --append /etc/fstab
  echo 'boson.lan:/srv/array1/dataspool /mnt/share1 nfs4 nouser,atime,rw,dev,exec,suid,auto    0  0'  | tee --append /etc/fstab
fi

###
# default settings for screen
echo "shell -\$SHELL" > $HOME/.screenrc
echo "defscrollback 10000" >> $HOME/.screenrc
echo "hardstatus on" >> $HOME/.screenrc
echo "hardstatus alwayslastline" >> $HOME/.screenrc
echo "hardstatus string \"%{.bW}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %l %{..Y} %Y-%m-%d %c \"" >> $HOME/.screenrc

# ssh
mkdir -m 0700 -p $HOME/.ssh

echo "\$HOME/bin/chkupdate.sh" >> $HOME/.profile

# WiFi
# ref: https://learn.adafruit.com/setting-up-wifi-with-beaglebone-black/configuration
pushd /tmp
  git clone https://github.com/adafruit/wifi-reset.git
  pushd wifi-reset
    chmod +x install.sh
    ./install.sh
  popd
popd
