{lib}: {
  username = "Tabi";
  userfullname = "Tabi";
  useremail = "jsaiomay123@gmail.com";
  # generated by `mkpasswd -m scrypt`
  initialHashedPassword = "$7$CU..../....AszwgGQPIP8/CzgVG/MVn/$PYJX6u6lPPALwYp85hR/HmfCmCWR8gmd4jAOiwlUel.";
  # Public Keys that can be used to login to all my PCs, Macbooks, and servers.
  #
  # Since its authority is so large, we must strengthen its security:
  # 1. The corresponding private key must be:
  #    1. Generated locally on every trusted client via:
  #      ```bash
  #      # KDF: bcrypt with 256 rounds, takes 2s on Apple M2):
  #      # Passphrase: digits + letters + symbols, 12+ chars
  #      ssh-keygen -t ed25519 -a 256 -C "ryan@xxx" -f ~/.ssh/xxx`
  #      ```
  #    2. Never leave the device and never sent over the network.
  # 2. Or just use hardware security keys like Yubikey/CanoKey.
}
