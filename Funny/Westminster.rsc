/system script
add name="Westminister Seq #1" owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff source=\
    "#Westminister Sequence #1\r\
    \n# E-660 D-588 C-528 G-396\r\
    \n# EDCG\r\
    \n:beep length=480ms frequency=660\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=588\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=528\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=396"
add name="Westminister Seq #2" owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff source=\
    "#Westminister Sequence #2\r\
    \n# E-660 D-588 C-528 G-396\r\
    \n# CEDG\r\
    \n:beep length=480ms frequency=528\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=660\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=588\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=396"
add name="Westminister Seq #3" owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff source=\
    "#Westminister Sequence #3\r\
    \n# E-660 D-588 C-523 G-396\r\
    \n# CDEC\r\
    \n:beep length=480ms frequency=523\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=588\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=659\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=528"
add name="Westminister Seq #4" owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff source=\
    "#Westminister Sequence #4\r\
    \n# E-660 D-588 C-528 G-396\r\
    \n# ECDG\r\
    \n:beep length=480ms frequency=660\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=528\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=588\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=396\r\
    \n"
add name="Westminister Seq #5" owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff source=\
    "#Westminister Sequence #5\r\
    \n# E-660 D-588 C-528 G-396\r\
    \n# GDEC\r\
    \n:beep length=480ms frequency=396\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=588\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=660\r\
    \n:delay 500ms\r\
    \n:beep length=480ms frequency=528"
add name="Westminister Chime" owner=admin policy=ftp,reboot,read,write,policy,test,password source="#Westminister Chime\r\
    \n#Chimes the number of times that the hour is.\r\
    \n:global h\r\
    \n:global ch\r\
    \n:if  ( \$h >12 ) do= {\r\
    \n:set ch  ( \$h - 12 )\r\
    \n:};\r\
    \n:if  ( \$h < 12 ) do= {\r\
    \n:set ch \$h\r\
    \n:}\r\
    \n:if  ( \$h=0 ) do= {\r\
    \n:set ch  ( \$h + 12 )\r\
    \n:}\r\
    \n\r\
    \n:for i from=1 to=\$ch step=1 do={\r\
    \n:beep length=1000ms frequency=440;\r\
    \n:delay 2000ms\r\
    \n:}"
add name=Westminister owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff source=":global c 11:00:00\r\
    \n:global h 0\r\
    \n:global m 0\r\
    \n:global s 0\r\
    \n:set c  [/system clock get time ]\r\
    \n:set h  [ :tonum  [:pick  \$c 0 2 ] ]\r\
    \n:set m  [ :tonum  [:pick  \$c 3 5 ] ]\r\
    \n:set s  [ :tonum  [:pick  \$c 6 8 ] ]\r\
    \n\r\
    \n#Really should put a limiter in here so it does not chime all night longwhen no one is around to hear it.\r\
    \n\r\
    \n# First-quarter Sequence 1\r\
    \n:if  (  \$m=15 ) do {/system script run  \"Westminister Seq #1\"}\r\
    \n\r\
    \n# Half-hour Sequence 2,3\r\
    \n:if  (  \$m = 30  ) do {/system script run  \"Westminister Seq #2\"}\r\
    \n:if  (  \$m = 30  ) do { :delay 2000ms }\r\
    \n:if  (  \$m = 30  ) do {/system script run  \"Westminister Seq #3\"}\r\
    \n\r\
    \n# Third-quarter Sequence 4,5,1\r\
    \n:if  (  \$m = 45  ) do {/system script run  \"Westminister Seq #4\"}\r\
    \n:if  (  \$m = 45  ) do { :delay 2000ms }\r\
    \n:if  (  \$m = 45  ) do {/system script run  \"Westminister Seq #5\"}\r\
    \n:if  (  \$m = 45  ) do { :delay 2000ms }\r\
    \n:if  (  \$m = 45  ) do {/system script run  \"Westminister Seq #1\"}\r\
    \n\r\
    \n# Full-hour Sequence 2,3,4,5\r\
    \n:if  (  \$m = 0  ) do {/system script run  \"Westminister Seq #2\"}\r\
    \n:if  (  \$m = 0  ) do { :delay 2000ms }\r\
    \n:if  (  \$m = 0  ) do {/system script run  \"Westminister Seq #3\"}\r\
    \n:if  (  \$m = 0  ) do { :delay 2000ms }\r\
    \n:if  (  \$m = 0  ) do {/system script run  \"Westminister Seq #4\"}\r\
    \n:if  (  \$m = 0  ) do { :delay 2000ms }\r\
    \n:if  (  \$m = 0  ) do {/system script run  \"Westminister Seq #5\"}\r\
    \n:if  (  \$m = 0  ) do { :delay 2000ms }\r\
    \n:if  (  \$m = 0  ) do {/system script run  \"Westminister Chime\"}\r\
    \n:if  (  \$m = 0  ) do { :delay 2000ms }"
/system scheduler
add interval=15m name=Westminister on-event=Westminister policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive start-date=jan/01/1970 start-time=00:00:00
