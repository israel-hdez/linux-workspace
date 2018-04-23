# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d $HOME/Projects/go ]; then
  export GOPATH=$HOME/Projects/go
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:$HOME/Projects/kube-tests/istio-0.6.0/bin"

if [ -n `which direnv` ]; then
  eval "$(direnv hook bash)"
fi
