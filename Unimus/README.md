# Deploying unimus with safe ssh authentication
A quick 'n dirty on deploying unimus with ssh keyauth instead of dirty password auth

1. Run ssh-keygen
2. Choose where to save pub and privkey
3. Upload pubkey to a https:// host, preferably one that runs php too for randomstring.php [1]
4. Upload privkey to unimus
5. Run script on every single MikroTik device you wanna join to Unimus [2]


1: Since MikroTik doesn't support disabling password authentication for users we genrate a long random password that we don't save anywhere and never see again

2: You should also edit the script to add a firewall rule that allows input traffic on port 22, I didn't add this here because you might want to limit the firewall rule to an address-list that you've already got deployed or something like that, your own responsibility.

