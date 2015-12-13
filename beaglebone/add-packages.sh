#echo "Installing WIFI support..."
#sudo apt-get -yuV install iw

ME=$(whoami)

echo "Installing packages..."
#probably already present:
sudo apt-get -yuV install apt-utils bc git htop screen logrotate lsof nano python rsync sudo wireless-tools wpasupplicant
# probably not yet installed
sudo apt-get -yuV install nfs-common gnuplot fake-hwclock
sudo apt-get -yuV install debian-keyring debian-archive-keyring
echo "Installing additional Python packages..."
sudo apt-get -yuV install build-essential python-dev python-setuptools python-pip python-smbus python-gnuplot

echo "Starting upgrade..."
sudo apt-get -yuV upgrade
