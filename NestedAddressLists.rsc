:local dynamictimeout 120

:local addedentry true
:while ($addedentry) do={
    :set addedentry false
    :foreach i in=[/ip firewall address-list find] do={
        :local tlist [/ip firewall address-list get $i list]
        :local taddr [/ip firewall address-list get $i address]

        foreach j in [/ip firewall address-list find where list=$taddr] do={
            :local dynaddress [/ip firewall address-list get $j address]
            :local comment [/ip firewall address-list get $j comment]
            :local parentdisabled false

            :if ([:len $comment] > 0) do={
                :do {
                    :set parentdisabled [/ip firewall address-list get [:toid $comment] disabled]
                } on-error { }
            }
            
            if ([:typeof [:toip $dynaddress]] = "ip" or [:typeof [:toip6 $dynaddress]] = "ip6") do={
                :local existingentry [/ip firewall address-list find where list=$tlist and address=$dynaddress]

                :if ([:len $existingentry] > 0) do={
                    :if ([/ip firewall address-list get $existingentry dynamic]  and !$parentdisabled) do={
                        /ip firewall address-list set $existingentry timeout=$dynamictimeout
                    }
                } else={
                    /ip firewall address-list add list=$tlist address=$dynaddress timeout=$dynamictimeout comment=[:tostr $i]
                    :set addedentry true
                }
            }
        }
    }
}
