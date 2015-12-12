#echo "Installing WIFI support..."
#sudo apt-get -yuV install iw

ME=$(whoami)

echo "Installing packages..."
#probably already present:
sudo apt-get -yuV install apt-utils bc git htop screen logrotate lsof nano python rsync sudo wireless-tools wpasupplicant
# probably not yet installed
sudo apt-get -yuV install nfs-common gnuplot
sudo apt-get -yuV debian-keyring debian-archive-keyring
echo "Installing additional Python packages..."
sudo apt-get -yuV install python-gnuplot
