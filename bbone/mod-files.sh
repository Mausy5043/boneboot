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
