# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" > /dev/null  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/dmitrirabinowitz/gitrep/SiteAppExtension/node_modules/tabtab/.completions/slss.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=/usr/local/mysql/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export GOPRIVATE="github.com/Klover-Fintech"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
source <(kubectl completion zsh)

export PATH=/Users/dmitrirabinowitz/istio-1.12.1/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dmitrirabinowitz/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dmitrirabinowitz/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dmitrirabinowitz/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dmitrirabinowitz/google-cloud-sdk/completion.zsh.inc'; fi
