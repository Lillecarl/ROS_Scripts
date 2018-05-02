##############Script Settings##################

:local NOIPUser   "user"
:local NOIPPass   "pass"
:local NOIPDomain "domain"

###############################################
#http://checkip.amazonaws.com/
#http://myip.dnsomatic.com/
#http://ipecho.net/plain

/tool fetch url="http://myip.dnsomatic.com/" mode=http dst-path=mypublicip.txt
:local IpCurrent [file get mypublicip.txt contents ]

:if ([:resolve $NOIPDomain] != $IpCurrent) do={
	/tool fetch mode=http user=$NOIPUser password=$NOIPPass url="http://dynupdate.no-ip.com/nic/update\3Fhostname=$NOIPDomain&myip=$IpCurrent" keep-result=no
	:log info "NO-IP Update: $NOIPDomain - $IpCurrent"
}
