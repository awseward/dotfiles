# ~/.oh-my-zsh/themes/andrewseward.zsh-theme
#
# This began as a modified version of version of the 'jispwoso' theme:
# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#jispwoso
#

# PROMPT=$'%{$fg[green]%}@%m:%{$reset_color%}%{$fg[blue]%}%2~ %{$reset_color%}%{$fg_bold[red]%}$(git_prompt_info)%{$fg_bold[___doesnt_seem_to_matter__not_sure_why_this_was_here__]%} % %{$reset_color%}
# ; '
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}[%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}] %{$fg[yellow]%}*%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%}]"

setopt PROMPT_SUBST
# This all but works… all that doesn't work is the exit code part :/
# TODO: Figure out why
PROMPT='$(~/.local/bin/zsh_prompt.ysh)'
