#echo "Installing WIFI support..."
#apt-get -yuV install iw

ME=$(whoami)
HERE=$(pwd)

echo "Installing packages..."
#probably already present:
apt-get -yuV install apt-utils bc git htop screen logrotate lsof nano python rsync wireless-tools wpasupplicant
# probably not yet installed
apt-get -yuV install nfs-common gnuplot fake-hwclock tree ntp
apt-get -yuV install debian-keyring debian-archive-keyring
# MySQL support
apt-get -yuV install mysql-client python-mysqldb
echo "Installing additional Python packages..."
apt-get -yuV install build-essential python-dev python-setuptools python-pip python-smbus python-gnuplot

# echo "Starting upgrade..."
# apt-get -yuV upgrade

sudo apt-get -y autoremove
sudo apt-get -y autoclean
