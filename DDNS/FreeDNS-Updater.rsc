:log warning ("FreeDNS script begin")
##############    Script FreeDNS.afraid.org   ##################
##############    CREATED LESHIY_ODESSA   ##################
##############    Improved by SEAN SCARFO  ##################
# Specify your domain or subdomain.
:global "dns-domain" "woot.hello.to"

# Define IP checker website variable.  Any website that returns only the ip address in text format. examples listed
#https://www.trackip.net/ip/
#http://wgetip.com/
#https://api.ipify.org/
#If not pointing to a specific file, must end in a /
# Case sensitive.
:global "wanChecker" "http://wgetip.com/"

#specify your internet interface.  naming does not have to be exact as long as it has "ether" in the name
:global "wanInterface" "ether1"


# Specify the "Direct URL", which is https://freedns.afraid.org/dynamic/
# In front of the sign "?" put a backslash "\".
:global "direct-url" "https://freedns.afraid.org/dynamic/update.php\?ZDhoRDVwzRpbTFjOjE2NjQ4NTQ4"

# Specify the URL API "ASCII"
# Log in under your account and open the page https://freedns.afraid.org/api/
# Then copy the URL of your site - Available API Interfaces : ASCII (!!! NOT XML !!!)
# ATTENTION!!!! Before the question mark, put a backslash "\".
:global "api-url" "https://freedns.afraid.org/api/\?action=getdyndns&v=2&sha=142c0fbd898046f1bbfa12016cc1"


       
# !!!!!!!!!!!!!!!!! Nothing more do not need to edit!!!!!!!!!!!!!!!!!
:global "current-ip"
:global "dns-domain-ip"
:if ([:len $"current-ip"] <7) do={
    :log error ("current-ip variable has no value, setting it to 1.2.3.4");
    :global "current-ip" 1.2.3.4;
} else={
    :log warning ("current IP varaible exists and has a value")
#pause for 1 seconds
:delay 1

#Fetch Current IP from ether1
:global "current-ip" [/ip address get value-name=address [find interface~$"wanInterface"]]
:global "current-ip-endloc" ([:len $"current-ip"] -3)
:global "current-ip" [:pick $"current-ip" 0 $"current-ip-endloc"]

# Compare global IP variables
# Compare the external IP with the IP address of the DNS domain.
    :if ($"current-ip" = $"dns-domain-ip") do={
    :log warning ("current-ip matches dns-domain-ip, script is done!")
    } else={
#pause for 1 seconds
:delay 1

	:log error ("$"current-ip" does not match $"dns-domain-ip", updating IP FreeDNS")
#pause for 1 seconds
:delay 1

#Fetch Last Known IP info from WanChecker       
    /tool fetch url="$wanChecker" dst-path="/wanCheckerfile.txt"
#pause for 1 seconds
:delay 1

# Find the current IP address on the external interface
    :global "current-ip" [/file get wanCheckerfile.txt contents]
#pause for 1 seconds
:delay 1
	
#Fetch Last Known IP info from FreeDNS       
    /tool fetch url=$"api-url" dst-path="/freedns.txt"
#pause for 1 seconds
:delay 1

# Find out the IP address of the domain using the API and parsing.
# Split the file
    :local "result" [/file get freedns.txt contents]
    :local "startloc" ([:find $result $"dns-domain"] + [:len $"dns-domain"] + 1)
    :local "endloc" ([:find $"result" "https" [:find $result $"dns-domain"]] -1)
    :global "dns-domain-ip" [:pick $"result" $"startloc" $"endloc"]
#pause for 1 seconds
:delay 1

# Compare global IP variables
# Compare the external IP with the IP address of the DNS domain.
    :if ($"current-ip" = $"dns-domain-ip") do={
    :log warning ("current-ip matches dns-domain-ip, script is done!")
    } else={
#pause for 1 seconds
:delay 1

# Send new IP to freedns.afraid.org our external IP by using Direct URL
    :log error ("Service Dynamic DNS: old IP address $"dns-domain-ip" for $"dns-domain" CHANGED to -> $"current-ip"")
    /tool fetch mode=https url=$"direct-url" keep-result=no
    }
}
}
:log warning ("FreeDNS script end")
