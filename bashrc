# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

if [ -d $HOME/Projects/go ]; then
  export GOPATH=$HOME/Projects/go
  export PATH="$PATH:$GOPATH/bin"
fi

# Add RVM to PATH for scripting, if RVM is installed.
# Make sure this is the last PATH variable change.
if [ -d "$HOME/.rvm/bin" ]; then
  export PATH="$PATH:$HOME/.rvm/bin"
fi

# Load local environment
if [ -f "$HOME/.bashrc.local" ]; then
  . $HOME/.bashrc.local
fi

# Load direnv
if [ -n `which direnv` ]; then
  eval "$(direnv hook bash)"
fi

# User specific aliases and functions

# Git
alias gitc='git commit -v'
alias gitcu='git commit -v -a'
alias gitca='git commit -v --amend'
alias gitcua='git commit -v -a --amend'
alias gitp='git push'
alias gitpf='git push -f'
alias gitpu='git push -u'
alias gitf='git fetch'
alias gitfu='git fetch upstream'
alias gitm='git merge'
alias gitmm='git merge upstream/master'
alias gitr='git rebase'
alias gitrm='git rebase master'
alias gitrc='git rebase --continue'
alias gita='git add'
alias gitau='git add -u'
alias gitd='git diff'
alias gits='git status'
alias gitb='git branch'
alias gitco='git checkout'

