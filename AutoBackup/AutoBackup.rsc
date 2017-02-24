:local saveUserDB false
:local saveSysBackup true
:local encryptSysBackup false
:local saveRawExport true
:local verboseRawExport false

:local FTPServer "ftphostname"
:local FTPPort 21
:local FTPUser "ftpusername"
:local FTPPass "ftppassword"


:local ts [/system clock get time]
:set ts ([:pick $ts 0 2].[:pick $ts 3 5].[:pick $ts 6 8])

:local ds [/system clock get date]
:set ds ([:pick $ds 7 11].[:pick $ds 0 3].[:pick $ds 4 6])

:local fname ("BACKUP-".[/system identity get name]."-".$ds."-".$ts)

:if ($saveUserDB) do={
  /tool user-manager database save name=($fname.".umb")
  :log info message="User Manager DB Backup Finished"
}

:if ($saveSysBackup) do={
  :if ($encryptSysBackup = true) do={ /system backup save name=($fname.".backup") }
  :if ($encryptSysBackup = false) do={ /system backup save dont-encrypt=yes name=($fname.".backup") }
  :log info message="System Backup Finished"
}

if ($saveRawExport) do={
  :if ($verboseRawExport = true) do={ /export verbose file=($fname.".rsc") }
  :if ($verboseRawExport = false) do={ /export file=($fname.".rsc") }
  :log info message="Raw configuration script export Finished"
}

:delay 5s

:local backupFileName ""

:foreach backupFile in=[/file find] do={
  :set backupFileName ([/file get $backupFile name])
  :if ([:typeof [:find $backupFileName $fname]] != "nil") do={
    :log info "Uploading $backupFileName to FTP"
    /tool fetch address=$FTPServer port=$FTPPort src-path=$backupFileName user=$FTPUser password=$FTPPass dst-path=$backupFileName mode=ftp upload=yes
  }
}

:delay 5s

:foreach backupFile in=[/file find] do={
  :if ([:typeof [:find [/file get $backupFile name] "BACKUP-"]]!= "nil") do={
    /file remove $backupFile
  }
}

:log info message="Successfully removed Temporary Backup Files"
:log info message="Automatic Backup Completed Successfully"