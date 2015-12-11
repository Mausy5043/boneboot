#echo "Installing WIFI support..."
#sudo apt-get -yuV install iw wireless-tools wpasupplicant

ME=$(whoami)

echo "Installing packages..."
#probably already present:
sudo apt-get -yuV install apt-utils bc git htop screen logrotate lsof nano python rsync sudo
# probably not yet installed
sudo apt-get -yuV install nfs-common gnuplot
echo "Installing additional Python packages..."
sudo apt-get -yuV install python-gnuplot
