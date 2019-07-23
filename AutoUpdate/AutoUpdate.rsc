:do {
    :local versioninfo [/system package update check-for-updates as-value]

    :if (($versioninfo->"installed-version") != ($versioninfo->"latest-version")) do={
        /log error ("Found new version " . ($versioninfo->"latest-version") . " installing now!")
        /system package update download
        :delay 5s
        /system reboot
    }
} on-error={
    /log error "AutoUpdate script errored out, please check"
}
