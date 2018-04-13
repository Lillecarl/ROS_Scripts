##############Script Settings##################

:local LocalAddr "local.tld"
:local RemoteAddr "remote.tld"
:local Interface "DynamicTunnel1"

##########################################

:local NewLocalAddr [:resolve $LocalAddr]
:local NewRemoteAddr [:resolve $RemoteAddr]

:local OldLocalAddr [/interface gre get [find name=$Interface ] local-address]
:local OldRemoteAddr [/interface gre get [find name=$Interface ] remote-address]

if ($NewLocalAddr != $OldLocalAddr) do={
    /interface gre set [find name=$Interface] local-address=$NewLocalAddr
    /log info "Local tunnel IP for $Interface has changed from $OldLocalAddr to $NewLocalAddr"
}

if ($NewRemoteAddr != $OldRemoteAddr) do={
    /interface gre set [find name=$Interface] remote-address=$NewRemoteAddr
    /log info "Remote tunnel IP for $Interface has changed from $OldRemoteAddr to $NewRemoteAddr"
}

:local OldFWAddr [/ip firewall filter get [find name=$Interface] src-address]
if ($NewRemoteAddr != $OldFWAddr) do={
    /ip firewall filter set [find name=$Interface] src-address=$NewRemoteAddr
    /log info "Tunnel FW IP for $Interface has changed from $OldFWAddr to $NewRemoteAddr"
}
