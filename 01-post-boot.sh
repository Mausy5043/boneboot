#! /bin/bash

# This script only gets executed if `/tmp/boneboot.reboot` is absent...
# /tmp is emptied at reboot, so everytime the server is rebooted,
# this script is executed.

CLNT=$(hostname)
ME=$(whoami)
HERE=$(pwd)

# /var/log is on tmpfs so recreate lastlog now
if [ ! -e /var/log/lastlog ]; then
  touch /var/log/lastlog
  chgrp utmp /var/log/lastlog
  chmod 664 /var/log/lastlog
fi

# Check if the $HOME/bin directory exists
if [ ! -d $HOME/bin ]; then
  echo "Create $HOME/bin ..."
  mkdir $HOME/bin
fi

# Check if /mnt is populated
if [ ! -d /mnt/backup ]; then
  echo "Create /mnt/backup ..."
  mkdir -p /mnt/backup
fi
if [ ! -d /mnt/share1 ]; then
  echo "Create /mnt/share1 ..."
  mkdir -p /mnt/share1
fi

# Additional scripts to be executed on the first boot after install.
if [ ! -e $HOME/.firstboot ]; then
  echo -n "First boot detected on "
  date

  # 1. Update the system
  echo "Updating..."
  # select a local source
  sed -i 's/us/nl/' /etc/apt/sources.list
  apt-get update

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
    cp $f /$g
  done

  # 4. Modify existing server specific configuration files
  echo "Modify installation..."
  if [ -e ./$CLNT/mod-files.sh ]; then
    source ./$CLNT/mod-files.sh
  fi

  echo "Install bonediagd..."
  git clone -b master https://github.com/Mausy5043/bonediagd.git $HOME/bonediagd
  echo "master" > $HOME/.bonediagd
  # set permissions
  chmod -R 0755 $HOME/bonediagd
  pushd $HOME/bonediagd
    #./install.sh
  popd

  echo "Install lnxdiagd..."
  git clone -b master https://github.com/Mausy5043/lnxdiagd.git $HOME/lnxdiagd
  echo "v1_0" > $HOME/.lnxdiagd
  # set permissions
  chmod -R 0755 $HOME/lnxdiagd
  pushd $HOME/lnxdiagd
    #./install.sh
  popd

  # Plant the flag and wrap up
  #if [ -e /bin/journalctl ]; then
    #usermod -a -G systemd-journal $ME
  #fi
  touch $HOME/.firstboot
  shutdown -r +2 "First boot installation completed. Please log off now."
  echo -n "First boot installation completed on "
  date
fi

# Download the contents for the $HOME/bin directory
# We use the `.rsyncd.secret` file as a flag.
# This allows a re-population of this directory in case new/updated binaries
# need to be installed.
if [ ! -e $HOME/bin/.rsyncd.secret ]; then
  echo "Populate $HOME/bin ..."
  # we use the long command here because /etc/fstab may not contain an entry yet.
  mount -t nfs boson.lan:/srv/array1/backup /mnt/backup -o nouser,atime,rw,dev,exec,suid,noauto
  cp -r  /mnt/backup/bbmain/bin/.   $HOME/bin
  cp -r  /mnt/backup/bbmain/.my.cnf $HOME/
  umount /mnt/backup
  # Set permissions
  chmod -R 0755 $HOME/bin
  chmod    0740 $HOME/bin/.rsyncd.secret
fi

echo "Boot detection mail... "$(date)
$HOME/bin/bootmail.py

cat /sys/devices/platform/bone_capemgr/slots

echo "**************************************************************************"
echo
echo " To upgrade to the latest kernel use:  /opt/scripts/tools/update_kernel.sh"
echo
echo "**************************************************************************"
