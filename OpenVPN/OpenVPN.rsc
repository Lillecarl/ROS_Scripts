# Delays are needed because MikroTik is a bit stupid regarding certificate generation.
{
    :local domainname "domainname.com"

    :delay 1s; /certificate add name=ca common-name=$domainname days-valid=3650 key-size=2048 key-usage=crl-sign,key-cert-sign
    :delay 1s; /certificate add name=server common-name=$domainname days-valid=3650 key-size=2048 key-usage=digital-signature,key-encipherment,tls-server
    :delay 1s; /certificate sign ca name=ca
    :delay 1s; /certificate sign server name=server ca=ca
    :delay 1s; /certificate export-certificate ca export-passphrase=""

    :delay 1s; /ip pool add name=ovpn ranges=10.128.128.2-10.128.128.253
    :delay 1s; /ppp profile add dns-server=10.128.128.1 interface-list=LAN local-address=10.128.128.1 name=ovpn remote-address=ovpn use-compression=no use-encryption=yes
    :delay 1s; /interface ovpn-server server set default-profile=ovpn certificate=server enabled=yes port=1194 auth=sha1 cipher=aes128
    :delay 1s; /ip firewall address-list add list=ovpn address=$domainname
    :delay 1s; /ip firewall filter add action=accept chain=input comment="accept openvpn" dst-address-list=ovpn dst-port=1194 protocol=tcp place-before=1
    :delay 1s; /ip firewall nat add action=dst-nat chain=dstnat comment="NAT port 53 for OpenVPN to port 1194" dst-address-list=ovpn dst-port=53 protocol=tcp to-ports=1194 disabled=yes
    :delay 1s; /ip firewall nat add action=dst-nat chain=dstnat comment="NAT port 80 for OpenVPN to port 1194" dst-address-list=ovpn dst-port=80 protocol=tcp to-ports=1194 disabled=yes
    :delay 1s; /ip firewall nat add action=dst-nat chain=dstnat comment="NAT port 443 for OpenVPN to port 1194" dst-address-list=ovpn dst-port=443 protocol=tcp to-ports=1194 disabled=yes
}
