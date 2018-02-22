# stratux-hotspot

This is for those who have a wifi only iPad, a personal hotspot, an extra wifi dongle, and wish to have access to the stratux and the internet at the same time.

On my RPI with the latest stratux image, I could not clone this repo due to a CA trust issue, so I had to clone with the following command:

```git -c http.sslVerify=false clone https://github.com/JohnRudolfLewis/stratux-hotspot```

Then run the script as root

```sudo stratux-hotspot/setup_hotspot.sh```

And finally, reboot your pi

``` sudo reboot 0```
