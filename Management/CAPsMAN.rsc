#CAPsMAN
if ([/interface bridge get 0 name] != "") do={
    /caps-man channel add control-channel-width=20mhz extension-channel=disabled name=channel reselect-interval=1h skip-dfs-channels=yes save-selected=yes
    /caps-man datapath add bridge=[/interface bridge get 0 name] client-to-client-forwarding=yes name=datapath
    /caps-man security add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm name=security1 passphrase=password123
    /caps-man configuration add channel=channel country=sweden datapath=datapath distance=indoors name=cfg1 security=security1 ssid=WiFi2
    /caps-man configuration add channel=channel country=sweden datapath=datapath distance=indoors name=cfg2 security=security1 ssid=WiFi5
    /caps-man access-list add action=accept interface=all signal-range=-90..120
    /caps-man access-list add action=reject disabled=no interface=all ssid-regexp=""
    /caps-man manager set enabled=yes
    /caps-man manager set upgrade-policy=suggest-same-version
    /caps-man provisioning add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=cfg1 name-format=prefix-identity name-prefix=cfg1
    /caps-man provisioning add action=create-dynamic-enabled hw-supported-modes=ac master-configuration=cfg2 name-format=prefix-identity name-prefix=cfg2

    /ip firewall filter add action=accept chain=input comment="CAPs to CAPsMAN" dst-port=5246,5247 protocol=udp src-address=127.0.0.1 place-before=1
}
