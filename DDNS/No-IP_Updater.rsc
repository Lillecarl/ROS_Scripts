##############Script Settings##################

:local NOIPUser "user"
:local NOIPPass "pass"
:local NOIPDomain "domain"
:local WANInter "ether1-gateway"

##########################################

:local IpCurrent [/ip address get [find interface=$WANInter] address];
:for i from=( [:len $IpCurrent] - 1) to=0 do={
  :if ( [:pick $IpCurrent $i] = "/") do={
    :local NewIP [:pick $IpCurrent 0 $i];
    :if ([:resolve $NOIPDomain] != $NewIP) do={
      /tool fetch mode=http user=$NOIPUser password=$NOIPPass url="http://dynupdate.no-ip.com/nic/update\3Fhostname=$NOIPDomain&myip=$NewIP" keep-result=no
      :log info "NO-IP Update: $NOIPDomain - $NewIP"
     }
   }
}
