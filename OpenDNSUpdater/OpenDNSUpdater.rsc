:local odnsusername "username"
:local odnspassword "password"
:local odnshostname "label"

# Do not edit below here

:global lastip

:local curip ([/tool fetch url="https://checkip.amazonaws.com/" mode=http output=user as-value]->"data")

if ($lastip != $curip) do={
    /tool fetch url="https://updates.opendns.com/nic/update\3Fhostname=$odnshostname" user=$odnsusername password=$odnspassword mode=http output=user as-value
    /log error "Updated OpenDNS public IP"
    :set $lastip $curip
}
