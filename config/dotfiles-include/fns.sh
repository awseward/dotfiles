# Just got tired of typing out `vim "$(which <script_filename>)"`, where the
# script is somewhere in $PATH
vhich() { vim "$(which "$1")"; }
