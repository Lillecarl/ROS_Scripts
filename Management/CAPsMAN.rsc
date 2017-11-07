# If the device you're running CAPsMAN on has WiFi cards too, make sure to allow the routers lan address in the firewall (If it doesn't work)
# i've filed a bug to MikroTik about local provisioning being blocked in FW, I'm sure they'll fix it.
#
# Please note that the version number specified below is noly what i've tested with, and not a guarantee.
# If you're running a device with just one switch group and no WiFi (Looking at hEX Gr3 =)) you'll need to create a bridge manually, add ether2 to it, move addresses etc...
# this information will be obsolteted once MikroTik's new bridge implementations

# >= 6.39.2:

/caps-man channel add control-channel-width=20mhz extension-channel=disabled name=channel1
/caps-man datapath add bridge=bridge name=datapath1
/caps-man security add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm name=security1 passphrase=WiFiPassword123
/caps-man configuration add channel=channel1 country=sweden datapath=datapath1 name=cfg1 security=security1 ssid=WiFi2g
/caps-man configuration add channel=channel1 country=sweden datapath=datapath1 name=cfg2 security=security1 ssid=WiFi5g
/caps-man access-list add action=accept interface=all signal-range=-90..120
/caps-man access-list add add action=reject disabled=no interface=all ssid-regexp=""
/caps-man manager set enabled=yes
/caps-man manager set upgrade-policy=suggest-same-version
/caps-man provisioning add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=cfg1 name-format=prefix-identity name-prefix=cfg1
/caps-man provisioning add action=create-dynamic-enabled hw-supported-modes=ac master-configuration=cfg2 name-format=prefix-identity name-prefix=cfg2
