##############Script Settings##################

:local LocalAddr "local.tld"
:local RemoteAddr "remote.tld"
:local CommentIDF "uniquecomment"

##########################################

:local NewLocalAddr [:resolve $LocalAddr]
:local NewRemoteAddr [:resolve $RemoteAddr]

:local OldLocalAddr [/interface eoip get [find comment=$CommentIDF ] local-address]
:local OldRemoteAddr [/interface eoip get [find comment=$CommentIDF ] remote-address]

if ($NewLocalAddr != $OldLocalAddr) do={
    /interface eoip set [find comment=$CommentIDF] local-address=$NewLocalAddr
    /log info "Local tunnel IP for $CommentIDF has changed from $OldLocalAddr to $NewLocalAddr"
}

if ($NewRemoteAddr != $OldRemoteAddr) do={
    /interface eoip set [find comment=$CommentIDF] remote-address=$NewRemoteAddr
    /log info "Remote tunnel IP for $CommentIDF has changed from $OldRemoteAddr to $NewRemoteAddr"
}

:local OldFWAddr [/ip firewall filter get [find comment=$CommentIDF] src-address]
if ($NewRemoteAddr != $OldFWAddr) do={
    /ip firewall filter set [find comment=$CommentIDF] src-address=$NewRemoteAddr
    /log info "Tunnel FW IP for $CommentIDF has changed from $OldFWAddr to $NewRemoteAddr"
}
