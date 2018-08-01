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

if [[ -s ~/ssh-find-agent.sh ]]; then
  . ~/ssh-find-agent.sh
  ssh-find-agent -a

  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval $(ssh-agent) > /dev/null
    ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
  fi
fi
export PATH="/usr/local/opt/node@8/bin:$PATH"
