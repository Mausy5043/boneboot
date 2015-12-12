# boneboot
Post-install / post-boot for BeagleBone Black

- Download the image from http://beagleboard.org/latest-images
- Un-`xz` the image. On OSX I use "The Unarchiver.app" available in the App Store.
- Format the SD-card. On OSX I use "SDFormatter.app" from the SD Association (https://www.sdcard.org/downloads/formatter_4/).
- Put the `.img`-file on the SD-card. I like to use "ApplePi-Baker.app" from http://www.tweaking4all.com/hardware/raspberry-pi/macosx-apple-pi-baker/
- Eject the SD-card and slip it into the BeagleBone Black.
- Apply power

- Open a terminal window and login onto the BBB: `$ ssh debian@beaglebone.lan`
- Start by setting a new password: `passwd`
- Next, clone the `boneboot` repo and run it:
```
echo "master" > .boneboot.branch
git clone https://github.com/Mausy5043/boneboot.git
cd boneboot
chmod 744 *
./00-run-scripts.sh
cd ..
tail -f post-boot.log
```
