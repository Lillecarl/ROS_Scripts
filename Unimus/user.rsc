:do { /file remove unimus.pub } on-error={}
:do { /user remove unimus } on-error={}
:do { /user group remove unimus  } on-error={}
:do {
    :put "Fetching random string as password"
    :local password [/tool fetch url="https://yourweb.tld/randomstring.php\?length=50" as-value output=user];
    :set password ($password->"data")
    :put "Downloading pubkey"
    /tool fetch url=https://yourweb.tld/unimus.pub
    :put "Adding unimus group"
    /user group add name=unimus policy=ssh,reboot,read,write,sensitive
    :put ("Adding user unimus with password: " . $password)
    /user add name=unimus group=full password=$password
    :delay delay-time=1s
    :put "Importing SSH key (We don't want password authentication)"
    /user ssh-keys import public-key-file="unimus.pub" user=unimus
    :put "Import finished without errors"
} on-error={
    :do { /file remove "unimus.pub" } on-error={}
    :do { /user remove unimus } on-error={}
    :do { /user group remove unimus  } on-error={}
}

