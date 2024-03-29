#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Source private.
if [[ -s "${ZDOTDIR:-$HOME}/.zprivate" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprivate"
fi

export FZF_TMUX=1
export FZF_TMUX_HEIGHT=50%
export KEYTIMEOUT=1
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:${ZDOTDIR:-$HOME}/Library/Android/sdk/platform-tools"
export PATH="$PATH:/usr/local/go/bin"
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"
export SP_REPO_PATH="${ZDOTDIR:-$HOME}/gitrep"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
source "$HOME/.cargo/env"
. "$HOME/.cargo/env"
