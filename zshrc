# Activate system completions
autoload -U compinit
compinit

# Activate vcs_info to customize prompt based on git state
autoload -Uz vcs_info

# History
# Reference: https://leetschau.github.io/remove-duplicate-zsh-history.html
# and https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh
# and https://www.soberkoder.com/better-zsh-history/
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_all_dups   # if command is already present in history, remove the one in the history
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_find_no_dups      # when searching history, ignore duplicated occcurrences
setopt hist_save_no_dups      # don't save duplicated commands when writing history file
setopt hist_verify            # show command with history expansion to user before running it
setopt hist_beep              # Beep in ZLE when a widget attempts to access a history entry which isn’t there.
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

# If NVM is present, load it
if [ -f "$HOME/apps/nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/apps/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# If chruby is present, load it
if [ -n "$ZSH_VERSION" ] && [ -f $HOME/.local/share/chruby/chruby.sh ]; then
  .  $HOME/.local/share/chruby/chruby.sh
fi

# If gem_home is present, load it
if [ -n "$ZSH_VERSION" ] && [ -f $HOME/.local/share/gem_home/gem_home.sh ]; then
  .  $HOME/.local/share/gem_home/gem_home.sh
fi


# Load local environment
if [ -f "$HOME/.zshrc.local" ]; then
  . $HOME/.zshrc.local
fi

# Load direnv
if type "direnv" &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# If go installation is present, add to PATH
if [ -f "$HOME/apps/go/bin/go" ]; then
  export PATH="$HOME/apps/go/bin/:$PATH"
  export GOPATH="$HOME/Projects/go"

  if [ -d "$HOME/Projects/go/bin" ]; then
    export PATH="$HOME/Projects/go/bin:$PATH"
  fi
fi


### Prompt customization
zstyle ':vcs_info:*' enable git 
#zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
#zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:*' actionformats '%K{cyan}%F{black} %r %K{green} %b %K{red} %a %K{250}%F{000} %S>'
zstyle ':vcs_info:*' formats '%K{cyan}%F{black} %r %K{green} %b %K{250}%F{000} %S>'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
precmd () {
  vcs_info

  if [ "$vcs_info_msg_0_" = '' ]; then
    _PMPT="
%K{250}%F{000} %~> %k%f %# "
  else
    _PMPT="
${vcs_info_msg_0_} %k%f %# "
  fi
}

setopt prompt_subst
#PS1='%F{5}[%F{2}%n%F{5}] %F{3}%3~ %k%f xX${vcs_info_msg_0_}Xx%f%# '

# default is PROMPT="[%n@%m]%~%# "
autoload -U colors && colors
PROMPT='$_PMPT'
#PROMPT="
#%K{250}%F{000} %~> %k%f %# "

