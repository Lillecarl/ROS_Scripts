foreach i in=[/ip firewall nat find] do={
	:local obj ([/ip firewall nat print as-value where .id=$i]->0);
	:if ([:len ($obj->"dst-port")] > 0 && ($obj->"dst-port") = ($obj->"to-ports")) do={
		:put "Removed To Ports for $($obj->"comment")"
		/ip firewall nat unset $i to-ports
	}
}
