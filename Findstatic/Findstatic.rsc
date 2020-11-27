{
    # Only include subnets from this array, probably never have to touch unless you already know what you're doing
    :local RFC1918 { "10.0.0.0/8";"172.16.0.0/12";"192.168.0.0/16" }
    # We only generate hairpins for subnets below /30
    :local subnetsbelow 255.255.255.252

	:local info [:toarray ""]
	:local ctr 0

	foreach i in=[/ip address find] do={
		:local curnet [/ip address get $i]
		
		:local inRFC1918 $false
        foreach j in=$RFC1918 do={
            :if (($curnet->"network") in $j) do={ :set inRFC1918 true }
        }
		
		if (($curnet->"netmask") < $subnetsbelow && $inRFC1918) do={
			# Fill the ARP
			/tool ip-scan address-range=($curnet->"address") interface=($curnet->"interface") duration=10
			
			/ip arp remove [find where !mac-address]
			# Check the ARP
			foreach k in=[/ip arp find where interface=($curnet->"interface")] do={
				:local curarp [/ip arp get $k]

				# Show IP/MAC combos not in a DHCP lease
				if ([:len [($curarp->"mac-address")]] > 0 && [len [/ip dhcp-server lease find where mac-address=($curarp->"mac-address")]] <= 0) do={
					#:put "IP $($curarp->"address") found with mac $($curarp->"mac-address"), not in DCHP"
					:set ($info->$ctr) "IP $($curarp->"address") found with mac $($curarp->"mac-address"), not in DCHP"
					#:put ($info->$ctr)
					:set ctr ($ctr + 1)
				}
			}
		}
	}

	foreach str in=$info do={
		:put $str
	}
}
