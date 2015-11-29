#echo "Installing WIFI support..."
#sudo apt-get -yuV install iw wireless-tools wpasupplicant

ME=$(whoami)

echo "Installing Arduino support..."
sudo apt-get -yuV install arduino

# make
# arduino-mk
echo "Installing Serial Port package..."
sudo apt-get -yuV install picocom
echo "Installing additional Python packages..."
sudo apt-get -yuV install python-dev python-setuptools python-serial
sudo apt-get -yuV install python-matplotlib python-bs4 python-lxml
sudo apt-get -yuV install python-mysqldb

# Retrieve and install Arduino support files
echo "Installing Arduino support..."
pushd /home/$ME
  git clone https://github.com/Mausy5043/arduino.git
  chmod -R 744 arduino/
  pushd arduino/ino
    python setup.py install
  popd
popd
