# ~/.oh-my-zsh/themes/andrewseward.zsh-theme
#
# This is a modified version of version of the 'jispwoso' theme:
# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#jispwoso
#

PROMPT=$'%{$fg[green]%}[%m] %{$reset_color%}%{$fg[cyan]%}%2~ %{$reset_color%}%{$fg_bold[white]%}$(git_prompt_info)%{$fg_bold[___doesnt_seem_to_matter___]%} % %{$reset_color%}
; '

# PROMPT2="%{$fg_blod[black]%}%_> %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}) %{$fg[yellow]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%})"
