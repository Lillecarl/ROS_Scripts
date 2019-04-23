/system script remove Unimus

/system script add name=Unimus owner=diadmin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":do { /file remove unimus.pub } on-error={}\r\
    \n:do { /user remove unimus } on-error={}\r\
    \n:do { /user group remove unimus  } on-error={}\r\
    \n:do {\r\
    \n    :put \"Fetching random string as password\"\r\
    \n    /tool fetch url=\"https://dialect.it/randomstring.php\?length=50\" dst-path=password.txt\r\
    \n    :delay delay-time=1s\r\
    \n    :local password [/file get password.txt contents ]\r\
    \n    /file remove password.txt\r\
    \n    :put \"Downloading pubkey\"\r\
    \n    /tool fetch url=\"https://dialect.it/unimus.pub\"\r\
    \n    :delay delay-time=1s\r\
    \n    :put \"Adding unimus group\"\r\
    \n    /user group add name=unimus policy=ssh,reboot,read,write,sensitive\r\
    \n    :put (\"Adding user unimus with password: \" . \$password)\r\
    \n    /user add name=unimus group=full password=\$password\r\
    \n    :delay delay-time=1s\r\
    \n    :put \"Importing SSH key (We don't want password authentication)\"\r\
    \n    /user ssh-keys import public-key-file=\"unimus.pub\" user=unimus\r\
    \n    :put \"Import finished without errors\"\r\
    \n    :put \"Adding access firewall rules\"\r\
    \n    /ip firewall address-list remove [/ip firewall address-list find where list=Safe !dynamic]\r\
    \n    /ip firewall address-list add address=management.dialect.it list=Safe\r\
    \n    /ip firewall filter remove [/ip firewall filter find where comment=\"Allow management from safe IP addresses\"]\r\
    \n    /ip firewall filter add action=accept chain=input comment=\"Allow management from safe IP addresses\" dst-port=22,8291 protocol=tcp src-address-list=Safe place-before=1\r\
    \n} on-error={\r\
    \n    :do { /file remove \"unimus.pub\" } on-error={}\r\
    \n    :do { /user remove unimus } on-error={}\r\
    \n    :do { /user group remove unimus  } on-error={}\r\
    \n}\r\
    \n"

:delay delay-time=1s
/system script run Unimus
/system script remove Unimus
