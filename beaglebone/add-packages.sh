# echo "Installing WIFI support..."
# apt-get -yuV install iw

ME=$(whoami)
HERE=$(pwd)

echo "Installing packages..."
apt-get -y autoremove
apt-get autoclean
# probably already present:
apt-get -yuV install apt-utils bc git htop screen logrotate lsof nano python rsync
# add keyrings if not already present
apt-get -yuV install debian-keyring debian-archive-keyring
# wireless-tools wpasupplicant
# probably not yet installed:
apt-get -yuV install nfs-common gnuplot-nox tree
# ntp fake-hwclock
# wavemon
# MySQL support:
apt-get -yuV install mysql-client python-mysqldb
echo "Installing additional Python packages..."
apt-get -yuV install build-essential python-dev python-setuptools python-pip python-smbus python-gnuplot python-openssl
