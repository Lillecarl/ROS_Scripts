:local architectures { "mipsbe" ; "arm" }
:local subfolder "caps"

foreach arch in=[$architectures] do={
    :local installedver [/system package update get installed-version]
    :local dlurl "https://download.mikrotik.com/routeros/$installedver/routeros-$arch-$installedver.npk"

    foreach i in=[/file find type="package" && package-version!=$installedver && package-architecture=$arch] do={
        /log error "Removing old $arch package $[/file get $i package-version]"
        /file remove $i
    }

    if ([:len [/file find package-version=$installedver && package-architecture=$arch]] = 0) do={
        /log error "Downloading new $arch package $installedver"
        /tool fetch url=$dlurl dst-path="$subfolder/routeros-$arch-$installedver"
    }
}
