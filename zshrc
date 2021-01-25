# Activate system completions
autoload -U compinit
compinit

# History
# Reference: https://leetschau.github.io/remove-duplicate-zsh-history.html
# and https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh
# [ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
# SAVEHIST=10000

## History command configuration
#setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_all_dups   # if command is already present in history, remove the one in the history
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_find_no_dups      # when searching history, ignore duplicated occcurrences
setopt hist_save_no_dups      # don't save duplicated commands when writing history file
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# Copied from /etc/inputrc
# (based on https://bbs.archlinux.org/viewtopic.php?pid=201942#p201942)
# (this is emacs input mode; see related article:
#    https://opensource.com/article/17/3/fun-vi-mode-your-shell)

# for linux console and RH/Debian xterm
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
# commented out keymappings for pgup/pgdown to reach begin/end of history
#bindkey "\e[5~" beginning-of-history
#bindkey "\e[6~" end-of-history
bindkey "\e[5~" history-search-backward
bindkey "\e[6~" history-search-forward
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word

# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# Hightlighting commands like the Fish shell
source $HOME/Projects/linux-workspace/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt customization
# default is PROMPT="[%n@%m]%~%# "
autoload -U colors && colors
PROMPT="
%K{250}%F{000} %~> %k%f %# "

# Load local environment
if [ -f "$HOME/.zshrc.local" ]; then
  . $HOME/.zshrc.local
fi

# Load direnv
if type "direnv" &> /dev/null; then
  eval "$(direnv hook zsh)"
fi
