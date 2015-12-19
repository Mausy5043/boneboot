#! /bin/bash

ME=$(whoami)
HERE=$(pwd)

branch=$(cat $HOME/.boneboot.branch)
git pull
git fetch origin
git checkout $branch && git reset --hard origin/$branch && git clean -f -d

# Set permissions
chmod -R 744 *
