###This Script will auto create vlans that are missing 
###Add the vlans you need to have in the newVlanArray variable by using "vlanid"="vlanName" and the script will do the rest
###BOF###
##Initialize variables

:global "physInterface" bridge-local
:global "newVlanArray" {"104"="104-CHCMGMT";"116"="116-security";"152"="152-userdata";"160"="160-printers";"168"="168-voice";"176"="176-wirelessi"}
:global "oldVlanArray" [/interface vlan find]
:global "COUNTER1" 0

##DO NOT CHANGE ANYTHING ELSE BELOW##
##
##
#Functions

#Create function to add all the vlans to the router

:global "AddAllVlans" do={
    :foreach k,v in=$newVlanArray do={/interface vlan add name=$v vlan-id=$k interface=$physInterface
    :put "VLAN $v has been added"
    }    
}


##
#Create Function to add a single vlan
:global "AddSingleVlan" do={
    /interface vlan add name=$1 vlan-id=$2 interface=$physInterface

###

#Check to see if there are any vlans on router.  If not, add all vlans
#If vlans exists, check to see if each one exists and create the ones that do not

:if ([:len $oldVlanArray] = 0) do={
    :put "No Vlans are on this router"
    $AddAllVlans
    :put "All New Vlans are now added"
else={
    :foreach k,v in=$newVlanArray do={
        set COUNTER1 0
        :foreach item in=$oldVlanArray do={
            :global oldvlanname [/interface vlan get value-name=name number=$item]
            :global oldvlanid [/interface vlan get value-name=vlan-id number=$item]
            :if ($oldvlanid !=$k) do={set COUNTER1 ($COUNTER1 +1)}}
        :if $COUNTER1 = ([:len $oldVlanArray]) do={$AddSingleVlan "$v" "$k"}
    }
}
###EOF###
