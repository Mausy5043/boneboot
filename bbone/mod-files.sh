echo "Modifying installation..."

# Install information about the wifi-network
#sudo cp /home/debian/bin/wpa.conf /etc/wpa_supplicant/wpa_supplicant.conf

echo "Setting timezone..."
sudo cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

echo "Regenerating locale..."
sudo locale-gen

# recreate ssh keys (call me paranoid)
echo "Regenerating SSH-keys..."
sudo rm /etc/ssh/ssh_host_*
sudo dpkg-reconfigure openssh-server

###
# default settings for screen
echo "shell -\$SHELL" > .screenrc
echo "defscrollback 10000" >> .screenrc
echo "hardstatus on" >> .screenrc
echo "hardstatus alwayslastline" >> .screenrc
echo "hardstatus string \"%{.bW}%-w%{.rW}%n %t%{-}%+w %=%{..G} %H %l %{..Y} %Y-%m-%d %c \"" >> .screenrc

# ssh
mkdir -m 0700 -p .ssh

echo "$HOME/bin/chkupdate.sh" >> .profile
