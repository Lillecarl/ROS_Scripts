:local listname "domaintoforward"

:local servercount [:len [/ip firewall address-list find where list=$listname]]
:local onlinecount 0

:foreach i in=[/ip firewall address-list find where list=$listname] do={
    :local listip [/ip firewall address-list get $i address]
    :do {
        :local resolvedns [:resolve $listname server=$listip]
        :set onlinecount ($onlinecount + 1)
        
        :do {
            :set resolvedns [:resolve $listname server=$resolvedns]
            /ip firewall address-list add list=$listname address=$resolvedns
        } on-error={ }
    } on-error={ }
}

:if ($onlinecount = 0) do={
    :put "All all listed DNS servers are offline, retry again when there are servers online."
    :error "Or add manually to address-list $listname."
}

:foreach i in=[/ip firewall address-list find where list=$listname] do={
    :local listip [/ip firewall address-list get $i address]
    :do {
        :resolve $listname server=$listip
        :if ([/ip firewall address-list get $i dynamic]) do={
            /ip firewall address-list remove $i
            /ip firewall address-list add list=$listname address=$listip
        }
    } on-error={
        /ip firewall address-list set $i timeout=1w
    }
}

:local newdns ([/ip firewall address-list get ([find where list=$listname and dynamic=no]->0) address])

:do {
    /ip firewall nat set ([find where comment=$listname]->0) to-addresses=$newdns
} on-error={
    :error "Can't find NAT rule with exact comment $listname"
}
