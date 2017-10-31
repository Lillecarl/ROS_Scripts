# This script will set a password and identity on all accesspoints it can connect to
# Intended for when you put up many capsman managed aps and want to secure them in one go.
# The identity part can be commented or removed if not needed
# Script will only work once, when there's no password on the AP

{
    :local Password "Coolpassword192"
    
    :local Counter 0
    :foreach neighbor in=[/ip neighbor find] do={
        :local Platform [/ip neighbor get $neighbor platform]
        :local IP [/ip neighbor get $neighbor address4]
        
        if ($Platform = "MikroTik") do={
            :local Identity "AP$Counter"
            /system ssh address=$IP user=admin command="/system identity set name=$Identity"
            /system ssh address=$IP user=admin command="/user set admin Password=$Password"
        }
        :set Counter ($Counter + 1)
    }
}
