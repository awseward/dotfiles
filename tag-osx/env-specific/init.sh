# Used by Fuse/Uno
export JAVA_HOME="$(/usr/libexec/java_home)"
export RACKET_BIN_DIR="/Applications/Racket v7.0/bin/"

__ensure_in_PATH "/usr/local/sbin"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
