#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

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

  if [[ -z "SSH_AGENT_PID" ]]; then
    eval $(ssh-agent) > /dev/null
    ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
  fi
fi
export PATH="/usr/local/opt/node@8/bin:$PATH"

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/dmitrirabinowitz/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/usr/local/opt/postgresql@10/bin:$PATH"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/slss.zsh