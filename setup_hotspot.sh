#
# force the built in wifi to wlan0
#
echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="brcmfmac", NAME="wlan0"' >> /etc/udev/rules.d/72-static-name.rules

#
# force the usb wifi interface to wlan1
#
foundwlan0=`grep "wlan0:" /proc/net/dev`
if  [ -n "$foundwlan0" ]
then
  driver=$(udevadm info /sys/class/net/wlan0 | grep 'E: ID_NET_DRIVER=' | sed -r 's/E: ID_NET_DRIVER=//')
  if [ "$driver" != "brcmfmac" ]
  then
    echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"$driver\", NAME=\"wlan1\"" >> /etc/udev/rules.d/72-static-name.rules
  fi
fi
foundwlan1=`grep "wlan1:" /proc/net/dev`
if  [ -n "$foundwlan1" ] ; then
  driver=$(udevadm info /sys/class/net/wlan1 | grep 'E: ID_NET_DRIVER=' | sed -r 's/E: ID_NET_DRIVER=//')
  if [ "$driver" != "brcmfmac" ]; then
    echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"$driver\", NAME=\"wlan1\"" >> /etc/udev/rules.d/72-static-name.rules
  fi
fi

#
# modify the /etc/network/interfaces file to configure the wlan1 interface
#
echo 'allow-hotplug wlan1' >> /etc/network/interfaces
echo 'iface wlan1 inet dhcp' >> /etc/network/interfaces
echo 'wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf' >> /etc/network/interfaces

#
# enable NAT
#
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

#
# start NAT
#
echo 1 > /proc/sys/net/ipv4/ip_forward

#
# configure iptables
#
iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT
iptables-save > /etc/iptables.ipv4.nat

#
# modify stratux wifi script
#
sed -i '/isc-dhcp-server start/ a\ \tiptables-restore < /etc/iptables.ipv4.nat' /usr/sbin/stratux-wifi.sh












