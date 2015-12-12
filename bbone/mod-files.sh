echo "Modifying installation..."

ME=$(whoami)

# Install information about the wifi-network
#sudo cp /home/debian/bin/wpa.conf /etc/wpa_supplicant/wpa_supplicant.conf

# Sometimes files have the wrong group. Correct that here
sudo find / -group 116 -exec chown root:root {} \;
# -exec chmod 744 {} \;

echo "Setting timezone..."
sudo cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

echo "Regenerating locale..."
sudo locale-gen "en_US.UTF-8"

# recreate ssh keys (call me paranoid)
echo "Regenerating SSH-keys..."
sudo rm /etc/ssh/ssh_host_*
sudo dpkg-reconfigure openssh-server

fstab_appended=$(sudo cat /etc/fstab |grep "boson" |wc -l)
if [ $fstab_appended==0 ]; then
  echo 'boson.lan:/srv/array1/backup    /mnt/backup nfs4 nouser,atime,rw,dev,exec,suid,noauto  0  0'  | sudo tee --append /etc/fstab
  echo 'boson.lan:/srv/array1/dataspool /mnt/share1 nfs4 nouser,atime,rw,dev,exec,suid,auto    0  0'  | sudo tee --append /etc/fstab
fi

###
# default settings for screen
echo "shell -\$SHELL" > /home/$ME/.screenrc
echo "defscrollback 10000" >> /home/$ME/.screenrc
echo "hardstatus on" >> /home/$ME/.screenrc
echo "hardstatus alwayslastline" >> /home/$ME/.screenrc
echo "hardstatus string \"%{.bW}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %l %{..Y} %Y-%m-%d %c \"" >> /home/$ME/.screenrc

# ssh
mkdir -m 0700 -p /home/$ME/.ssh

echo "\$HOME/bin/chkupdate.sh" >> /home/$ME/.profile
