# ~/.oh-my-zsh/themes/andrewseward.zsh-theme
#
# This began as a modified version of version of the 'jispwoso' theme:
# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#jispwoso
#

PROMPT='%{$fg[green]%}@%m:%{$reset_color%}%{$fg[blue]%}%2~%{$reset_color%} $(git_prompt_info) %(?..%{$fg[yellow]%}%{$bg[red]%}%?%{$reset_color%})
; '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{%{$fg[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"
