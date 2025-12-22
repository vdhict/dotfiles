# fzf - fuzzy finder
set -gx FZF_DEFAULT_COMMAND "fd -H -E .git"
set -gx FZF_DEFAULT_OPTS "--cycle --layout=reverse --border --height=90% --preview-window=wrap"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fd -H -E .git --type d"
