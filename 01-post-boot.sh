#! /bin/bash

# This script only gets executed if `/tmp/boneboot.reboot` is absent...
# /tmp is in RAMFS, so everytime the server is rebooted, this script is executed.

CLNT=$(hostname)
ME=$(whoami)

# /var/log is on tmpfs so recreate lastlog now
if [ ! -e /var/log/lastlog ]; then
  sudo touch /var/log/lastlog
  sudo chgrp utmp /var/log/lastlog
  sudo chmod 664 /var/log/lastlog
fi

# Check if the /home/$ME/bin directory exists
if [ ! -d /home/$ME/bin ]; then
  echo "Create /home/$ME/bin ..."
  mkdir /home/$ME/bin
fi

# Download the contents for the /home/$ME/bin directory
# We use the `.rsyncd.secret` file as a flag.
# This allows a re-population of this directory in case new/updated binaries
# need to be installed.
if [ ! -e /home/$ME/bin/.rsyncd.secret ]; then
  echo "Populate /home/$ME/bin ..."
  sudo mount /mnt/backup
  cp -r /mnt/backup/bbmain/bin/. /home/$ME/bin
  sudo umount /mnt/backup
  # Set permissions
  chmod -R 0755 /home/$ME/bin
  chmod    0740 /home/$ME/bin/.rsyncd.secret
fi

echo "Boot detection mail... "$(date)
/home/$ME/bin/bootmail.py

# Additional scripts to be executed on the first boot after install.
if [ ! -e /home/$ME/.firstboot ]; then
  echo -n "First boot detected on "
  date

  # 1. Update the system
  echo "Updating..."
  sudo apt-get update
  #echo "Upgrading..."
  #sudo apt-get -yuV upgrade

  # 2. Install server specific-packages
  echo "Additional packages installation..."
  if [ -e ./$CLNT/add-packages.sh ]; then
    source ./$CLNT/add-packages.sh
  fi

  # 3. Install server specific configuration files
  echo "Copy configuration files..."
  for f in ./$CLNT/config/*; do
    g=$(echo $(basename $f) | sed 's/@/\//g')
    echo $f " --> " $g
    # path must already exist for this to work:
    sudo cp $f /$g
  done

  # 4. Modify existing server specific configuration files
  echo "Modify installation..."
  if [ -e ./$CLNT/mod-files.sh ]; then
    source ./$CLNT/mod-files.sh
  fi

  echo "Install bonediagd..."
  git clone -b master https://github.com/Mausy5043/bonediagd.git /home/$ME/bonediagd
  # set permissions
  chmod -R 0755 /home/$ME/bonediagd
  pushd /home/$ME/bonediagd
    ./install.sh
  popd

  # Plant the flag and wrap up
  if [ -e /bin/journalctl ]; then
    sudo usermod -a -G systemd-journal $ME
  fi
  touch /home/$ME/.firstboot
  sudo shutdown -r +1 "First boot installation completed. Please log off now."
  echo -n "First boot installation completed on "
  date
fi
