:foreach i in=[/ip dhcp-server lease find] do={
    :local hostname [/ip dhcp-server lease get $i host-name] 

    :if ($hostname~"ipad|iPad|android|Android|iphone|iPhone") do={
        :local ipaddr [/ip dhcp-server lease get $i address] 
        :local expire [/ip dhcp-server lease get $i expires-after] 
        /ip firewall address-list add address=$ipaddr list=CellPhones timeout=$expire
    }
}