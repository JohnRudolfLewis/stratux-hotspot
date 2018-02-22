# stratux-hotspot

This is for those who have a wifi only iPad, a personal hotspot, an extra wifi dongle, and wish to have access to the stratux and the internet at the same time.

On my RPI with the latest stratux image (1.4r4), I could not clone this repo due to a CA trust issue, so I had to clone with the following command:

```git -c http.sslVerify=false clone https://github.com/JohnRudolfLewis/stratux-hotspot```

Then run the script as root

```sudo stratux-hotspot/setup_hotspot.sh```

And finally, reboot your pi

``` sudo reboot 0```

If you have any trouble, create an issue here with repro steps, and if I have time I'll investigate.

## Credits

Started by following this guide:
https://www.reddit.com/r/stratux/comments/70pmmt/guide_turn_your_stratux_into_a_internet/

But my rpi kept insisting on making the usb wifi wlan0 and the built in wifi as wlan0, which prevented the stratux software from workering properly.

So I followed this:
https://www.raspberrypi.org/forums/viewtopic.php?t=198687&start=25

Then I rolled it all into a single script that should be easier to use.
