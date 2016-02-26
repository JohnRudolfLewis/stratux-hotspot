#
# force the built in wifi to wlan0
#
echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="brcmfmac", NAME="wlan0"' >> /etc/udev/rules.d/72-static-name.rules

#
# force the usb wifi interface to wlan1
# TODO edit the DRIVERS=="*" to match the driver for your usb wifi interface 
#
echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="rtl8192cu", NAME="wlan1"' >> /etc/udev/rules.d/72-static-name.rules

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

#
# modify wpa supplicant
# TODO modify the ssid and psk to match your network
#
cat << EOF >> /etc/wpa_supplicant/wpa_supplicant.conf
network={
	ssid="HomeWifiSSID"
	psk="password"
}

network={
	ssid="PortableHotspotSSID"
	psk="password"
}
EOF

