set -x JAVA_HOME (/usr/libexec/java_home)
set -g -x PATH /usr/local/bin $PATH
set -g -x fish_greeting ''
set -g -x FZF_TMUX 0
set -g -x SP_REPO_PATH /Users/dmitrirabinowitz/gitrep
set -g -x GOPATH /Users/dmitrirabinowitz/gopath/
fish_vi_mode
function my_vi_bindings
  fish_vi_key_bindings
  bind -M insert -m default \cc backward-char force-repaint
end
set -g fish_key_bindings my_vi_bindings
source ~/.config/fish/functions/fish_user_key_bindings.fish
