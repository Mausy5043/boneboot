#! /bin/bash

CLNT=$(hostname)
ME=$(whoami)

# Timestamp the logfile
date

# Change PWD to the binaries directory
pushd /home/$ME/boneboot
  ./02-update-scripts.sh
  # Boot detection
  if [ ! -e /tmp/boneboot.reboot ]; then
    # Set the flag first to prevent recursive execution
    whoami > /tmp/boneboot.reboot
    git config core.fileMode false
    ( ./01-post-boot.sh 2>&1 | tee -a ../post-boot.log | logger -p local7.info -t 01-post-boot ) &
  fi

  # Execute client-specific scripts
  case "$CLNT" in
    bbone )   echo "BeagleBone Black"
              ;;
    * )       echo "!! undefined client !!"
              ;;
  esac

  date
popd
