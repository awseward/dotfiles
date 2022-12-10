let home = env:HOME as Text

in  { WORKING_DIRECTORY = home
    , PATH_PRE = "/run/current-system/sw/bin:"
    , PATH_POST = ":${home}/.bin"
    , ENV_KEYPAIRS_XML =
        ''

        <!-- Needed by curl installed via nixpkgs -->
        <key>NIX_SSL_CERT_FILE</key>
        <string>/etc/ssl/certs/ca-certificates.crt</string>
        ''
    }
