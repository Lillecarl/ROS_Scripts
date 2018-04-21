# How to use:
# Comment a tunnel something like the line below (no need for the #)
# LocalDNS:somedomain.com RemoteDNS:someotherdomain.com
# You don't have to use both LocalDNS and RemoteDNS, they're optional, if they're not found in a comment the tunnel is skipped
# You can choose to only use LocalDNS or RemoteDNS, or both.
# Schedule this script to run once a minute
# See it resolve and fix all your tunnels


:local LocalDNSPrefix "LocalDNS:"
:local RemoteDNSPrefix "RemoteDNS:"

:foreach i in=[/interface eoip find] do={
    :local ifacename [/interface eoip get $i name]
    :local comment [/interface eoip get $i comment]

    :local localdnsnamepos [:find $comment $LocalDNSPrefix -1]
    if ([:len $localdnsnamepos] > 0) do={
        :local start ($localdnsnamepos + [:len $LocalDNSPrefix])
        :local end ([:find $comment " " ($localdnsnamepos + [:len $LocalDNSPrefix])])
        if ([:len $end] = 0) do={
            :set end [:len $comment]
        }
        :local dnsname [:pick $comment $start $end]
        :local currentip [/interface eoip get $i local-address]
        :local newip [:resolve $dnsname]
        if ($currentip != $newip) do={
            :log info "Updating tunnel $ifacename with local-address $newip"
            /interface eoip set $i local-address $newip
        }
    }

    :local remotednsnamepos [:find $comment $RemoteDNSPrefix -1]
    if ([:len $remotednsnamepos] > 0) do={
        :local start ($remotednsnamepos + [:len $RemoteDNSPrefix])
        :local end ([:find $comment " " ($remotednsnamepos + [:len $RemoteDNSPrefix])])
        if ([:len $end] = 0) do={
            :set end [:len $comment]
        }
        :local dnsname [:pick $comment $start $end]
        :local currentip [/interface eoip get $i remote-address]
        :local newip [:resolve $dnsname]
        if ($currentip != $newip) do={
            :log info "Updating tunnel $ifacename with remote-address $newip"
            /interface eoip set $i remote-address $newip
        }
    }
}

:foreach i in=[/interface gre find] do={
    :local ifacename [/interface gre get $i name]
    :local comment [/interface gre get $i comment]

    :local localdnsnamepos [:find $comment $LocalDNSPrefix -1]
    if ([:len $localdnsnamepos] > 0) do={
        :local start ($localdnsnamepos + [:len $LocalDNSPrefix])
        :local end ([:find $comment " " ($localdnsnamepos + [:len $LocalDNSPrefix])])
        if ([:len $end] = 0) do={
            :set end [:len $comment]
        }
        :local dnsname [:pick $comment $start $end]
        :local currentip [/interface gre get $i local-address]
        :local newip [:resolve $dnsname]
        if ($currentip != $newip) do={
            :log info "Updating tunnel $ifacename with local-address $newip"
            /interface gre set $i local-address $newip
        }
    }

    :local remotednsnamepos [:find $comment $RemoteDNSPrefix -1]
    if ([:len $remotednsnamepos] > 0) do={
        :local start ($remotednsnamepos + [:len $RemoteDNSPrefix])
        :local end ([:find $comment " " ($remotednsnamepos + [:len $RemoteDNSPrefix])])
        if ([:len $end] = 0) do={
            :set end [:len $comment]
        }
        :local dnsname [:pick $comment $start $end]
        :local currentip [/interface gre get $i remote-address]
        :local newip [:resolve $dnsname]
        if ($currentip != $newip) do={
            :log info "Updating tunnel $ifacename with remote-address $newip"
            /interface gre set $i remote-address $newip
        }
    }
}

:foreach i in=[/interface ipip find] do={
    :local ifacename [/interface ipip get $i name]
    :local comment [/interface ipip get $i comment]

    :local localdnsnamepos [:find $comment $LocalDNSPrefix -1]
    if ([:len $localdnsnamepos] > 0) do={
        :local start ($localdnsnamepos + [:len $LocalDNSPrefix])
        :local end ([:find $comment " " ($localdnsnamepos + [:len $LocalDNSPrefix])])
        if ([:len $end] = 0) do={
            :set end [:len $comment]
        }
        :local dnsname [:pick $comment $start $end]
        :local currentip [/interface ipip get $i local-address]
        :local newip [:resolve $dnsname]
        if ($currentip != $newip) do={
            :log info "Updating tunnel $ifacename with local-address $newip"
            /interface ipip set $i local-address $newip
        }
    }

    :local remotednsnamepos [:find $comment $RemoteDNSPrefix -1]
    if ([:len $remotednsnamepos] > 0) do={
        :local start ($remotednsnamepos + [:len $RemoteDNSPrefix])
        :local end ([:find $comment " " ($remotednsnamepos + [:len $RemoteDNSPrefix])])
        if ([:len $end] = 0) do={
            :set end [:len $comment]
        }
        :local dnsname [:pick $comment $start $end]
        :local currentip [/interface ipip get $i remote-address]
        :local newip [:resolve $dnsname]
        if ($currentip != $newip) do={
            :log info "Updating tunnel $ifacename with remote-address $newip"
            /interface ipip set $i remote-address $newip
        }
    }
}
