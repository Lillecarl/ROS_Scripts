# How to use:
# Comment a tunnel something like the line below (no need for the #)
# LocalDNS:somedomain.com RemoteDNS:someotherdomain.com
# You don't have to use both LocalDNS and RemoteDNS, they're optional, if they're not found in a comment the tunnel is skipped
# You can choose to only use LocalDNS or RemoteDNS, or both.
# Schedule this script to run once a minute
# See it resolve and fix all your tunnels

:local LocalDNSPrefix "LocalDNS:"
:local RemoteDNSPrefix "RemoteDNS:"

# Arguments: DNSPrefix, EntryComment
:local GetAddressFromComments do={
    :local DNSnamepos [:find $EntryComment $DNSPrefix -1]
    if ([:len $DNSnamepos] > 0) do={
        :local start ($DNSnamepos + [:len $DNSPrefix])
        :local end ([:find $EntryComment " " ($DNSnamepos + [:len $DNSPrefix])])
        
        if ([:len $end] = 0) do={
            :set end [:len $EntryComment]
        }
        :local ExtractedDNSName [:pick $EntryComment $start $end]
        :local ResolvedIP ""
        
        :do {
            :set ResolvedIP [:resolve $ExtractedDNSName]
        } on-error={
            return ""
        }
        return $ResolvedIP
    }
    return ""
}

# Arguments: LocalDNSPrefix, RemoteDNSPrefix, menu
:local ProcessTunnels do={
    # Forward declaration of function
    :local GetAddressFromComments;

    # [:parse ($menu . " command")] will resolve to whatever menu is specified in the function call

    :foreach i in=[[:parse ($menu . " find")]] do={
        :local ifacename [[:parse ($menu . " get $i name")]]
        :local comment [[:parse ($menu . " get $i comment")]]

        :local newip [$GetAddressFromComments DNSPrefix=$LocalDNSPrefix EntryComment=$comment]

        if ([:len $newip] <= 0) do={
            :log info "Skipping update on tunnel $ifacename, nxdomain"
        } else={
            if ($currentip != $newip) do={
                [:parse ($menu . " set $i local-address $newip")]
                :log info "Updated tunnel $ifacename with local-address $newip"
            }
        }

        :set newip [$GetAddressFromComments DNSPrefix=$RemoteDNSPrefix EntryComment=$comment]

        if ([:len $newip] <= 0) do={
            :log info "Skipping update on tunnel $ifacename, nxdomain"
        } else={
            if ($currentip != $newip) do={
                [:parse ($menu . " set $i remote-address $newip")]
                :log info "Updated tunnel $ifacename with remote-address $newip"
            }
        }
    }
}

foreach i in=[/ip ipsec peer find where !dynamic] do={
    :local tunnelname [/ip ipsec peer get $i name]
	:local comment [/ip ipsec peer get $i comment]
    :local newip [$GetAddressFromComments DNSPrefix=$LocalDNSPrefix EntryComment=$comment]

    if ([:len $newip] <= 0) do={
        :log info "Skipping update on ipsec tunnel $tunnelname, nxdomain"
    } else={
        if ($currentip != $newip) do={
            /ip ipsec peer set $i local-address=$newip
            :log info "Updated ipsec tunnel $tunnelname with local address $newip"
        }
    }

    :set newip [$GetAddressFromComments DNSPrefix=$LocalDNSPrefix EntryComment=$comment]

    if ([:len $newip] <= 0) do={
        :log info "Skipping remote update on ipsec tunnel $tunnelname, nxdomain"
    } else={
        if ($currentip != $newip) do={
            /ip ipsec peer set $i address=$newip
            :log info "Updated ipsec tunnel $tunnelname with remote address $newip"
        }
    }
}

$ProcessTunnels LocalDNSPrefix=$LocalDNSPrefix RemoteDNSPrefix=$RemoteDNSPrefix menu="/interface gre" 
$ProcessTunnels LocalDNSPrefix=$LocalDNSPrefix RemoteDNSPrefix=$RemoteDNSPrefix menu="/interface eoip" 
$ProcessTunnels LocalDNSPrefix=$LocalDNSPrefix RemoteDNSPrefix=$RemoteDNSPrefix menu="/interface ipip" 
