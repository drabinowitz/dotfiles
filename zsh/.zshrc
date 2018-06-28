#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

bindkey -M viins "^M" accept-line
bindkey -M viins "^n" vi-cmd-mode
bindkey -M viins "^x" vi-add-eol

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
