# How to use:
# Comment a tunnel something like the line below (no need for the #)
# LocalDNS:somedomain.com RemoteDNS:someotherdomain.com
# You don't have to use both LocalDNS and RemoteDNS, they're optional, if they're not found in a comment the tunnel is skipped
# You can choose to only use LocalDNS or RemoteDNS, or both.
# Schedule this script to run once a minute
# See it resolve and fix all your tunnels

:local LocalDNSPrefix "LocalDNS:"
:local RemoteDNSPrefix "RemoteDNS:"

:local ProcessTunnels do={
# [:parse ($menu . " command")] will resolve to whatever menu is specified in the function call
    :foreach i in=[[:parse ($menu . " find")]] do={
        :local ifacename [[:parse ($menu . " get $i name")]]
        :local comment [[:parse ($menu . " get $i comment")]]

        :local localdnsnamepos [:find $comment $LocalDNSPrefix -1]
        if ([:len $localdnsnamepos] > 0) do={
            :local start ($localdnsnamepos + [:len $LocalDNSPrefix])
            :local end ([:find $comment " " ($localdnsnamepos + [:len $LocalDNSPrefix])])
            if ([:len $end] = 0) do={
                :set end [:len $comment]
            }
            :local dnsname [:pick $comment $start $end]
            :local currentip [[:parse ($menu . " get $i local-address")]]
            :local newip ""
            :do { :set newip [:resolve $dnsname] } on-error={}
            if ([:len $newip] <= 0) do={
                :log info "Skipping update on tunnel $ifacename, nxdomain"
            } else={
                if ($currentip != $newip) do={
                    [:parse ($menu . " set $i local-address $newip")]
                    :log info "Updated tunnel $ifacename with local-address $newip"
                }
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
            :local currentip [[:parse ($menu . " get $i remote-address")]]
            :local newip ""
            :do { :set newip [:resolve $dnsname] } on-error={}
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
}

$ProcessTunnels LocalDNSPrefix=$LocalDNSPrefix RemoteDNSPrefix=$RemoteDNSPrefix menu="/interface gre" 
$ProcessTunnels LocalDNSPrefix=$LocalDNSPrefix RemoteDNSPrefix=$RemoteDNSPrefix menu="/interface eoip" 
$ProcessTunnels LocalDNSPrefix=$LocalDNSPrefix RemoteDNSPrefix=$RemoteDNSPrefix menu="/interface ipip" 
