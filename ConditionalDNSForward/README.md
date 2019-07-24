You'll need these rules to make the failover script to work

The script is only required if you've got several internal DNS servers and you want to failover between them if they go down.

The script will remove stale entries too, relies on arecords existing with the root domain pointing to the dns servers (Like Microsoft Active Directory)

```
/ip firewall mangle
add action=mark-connection chain=prerouting connection-mark=no-mark dst-port=53 layer7-protocol=domaintoforward \
    new-connection-mark=domaintoforward passthrough=yes protocol=tcp
add action=mark-connection chain=prerouting connection-mark=no-mark dst-port=53 layer7-protocol=domaintoforward \
    new-connection-mark=domaintoforward passthrough=yes protocol=udp

/ip firewall nat
add action=dst-nat chain=dstnat comment=central.dialect.se connection-mark=domaintoforward to-addresses=adnsserver
add action=masquerade chain=srcnat connection-mark=domaintoforward

/ip firewall layer7-protocol
add name=domaintoforward regexp=domaintoforward
```
