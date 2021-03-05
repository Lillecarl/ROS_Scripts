# Secret to put in sms to execute commands
:local secret "smssecret"

# Command table
:local commands { "reboot"="/system reboot" }

foreach i in=[/tool sms inbox find] do={
    :local sms [/tool sms inbox get $i]

    :foreach k,v in=$commands do={
        if (([:len ([:find ($sms->"message") $k -1]) ] > 0) && ([:len ([:find ($sms->"message") $secret -1]) ] > 0)) do={
            :local func [:parse $v]
            $func
        }
    }
    /tool sms inbox remove $i
}
