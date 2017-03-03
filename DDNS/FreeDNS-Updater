##############    Script FreeDNS.afraid.org   ##################
##############    PARSER EDITION   ##################
##############    CREATED LESHIY_ODESSA   ##################
##############    Improved by SEAN SCARFO  ##################
# Specify your domain or subdomain.
:global "dns-domain" "et.phone.home"

# Define IP checker website variable.  Any website that returns only the ip address in text format. examples listed
#https://www.trackip.net/ip/
#http://wgetip.com/
#https://api.ipify.org/
#If not pointing to a specific file, must end in a /
# Case sensitive.
:global "wanChecker" "http://wgetip.com/"

# Specify the "Direct URL", which is https://freedns.afraid.org/dynamic/
# In front of the sign "?" put a backslash "\".
:global "direct-url" "https://freedns.afraid.org/dynamic/update.php\?123456789"

# Specify the URL API "ASCII"
# Log in under your account and open the page https://freedns.afraid.org/api/
# Then copy the URL of your site - Available API Interfaces : ASCII (!!! NOT XML !!!)
# ATTENTION!!!! Before the question mark, put a backslash "\".
:global "api-url" "https://freedns.afraid.org/api/\?action=getdyndns&v=2&sha=123456789"


       
# !!!!!!!!!!!!!!!!! Nothing more do not need to edit!!!!!!!!!!!!!!!!!
:global "current-ip"
:global "dns-domain-ip"
:if ([:len $"current-ip"] <7) do={
    :log error ("current-ip variable has no value, setting it to 1.1.1.1");
    :global "current-ip" 1.1.1.1;
} else={
    :log warning ("current IP varaible exists and has a value")

# Compare global IP variables
# Compare the external IP with the IP address of the DNS domain.
    :if ($"current-ip" = $"dns-domain-ip") do={
    :log warning ("current-ip matches dns-domain-ip, script is done!")
    } else={

#Fetch Last Known IP info from FreeDNS       
    /tool fetch url=$"api-url" dst-path="/freedns.txt"
#Fetch Current WAN IP from the Web
    /tool fetch url="$wanChecker" dst-path="/wanCheckerfile.txt"

# Find out the IP address of the domain using the API and parsing.
# Split the file
    :local "result" [/file get freedns.txt contents]
    :local "startloc" ([:len $"dns-domain"] + 1)
    :local "endloc" ([:find $"result" "https" -1] -1)
    :global "dns-domain-ip" [:pick $"result" $"startloc" $"endloc"]
       
# Find the current IP address on the external interface
    :global "current-ip" [/file get wanCheckerfile.txt contents]

# Send new IP to freedns.afraid.org our external IP by using Direct URL
    :log error ("Service Dynamic DNS: old IP address $"dns-domain-ip" for $"dns-domain" CHANGED to -> $"current-ip"")
    /tool fetch mode=https url=$"direct-url" keep-result=no
    }
}
##############Script FreeDNS.afraid.org##################
