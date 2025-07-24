# There are some ways to alter invocations of programs:
#
# * nocorrect: don't suggest a correction
# * noglob: don't interpret glob patterns

alias ":q"='exit'

alias reload="killall -USR1 -- zsh -zsh"

alias cz='chezmoi'
alias brewdump="brew bundle dump --no-vscode --force --file ~/.local/share/chezmoi/Brewfile && bat ~/.local/share/chezmoi/Brewfile"
alias brewload="brew bundle install --file ~/.local/share/chezmoi/Brewfile"
alias brew-reverse-deps="brew uses --recursive --installed"

# alias ls='gls -l --color=auto --group-directories-first --classify'
alias ls='eza --all --long --group --group-directories-first --color=always'
alias lz='eza -l'
alias mounts='mount | column -t | sort'
alias ports='netstat -tulanp'

alias less='less -FXr'
alias -g eless='2>&1 | less'

alias tsup='sudo ntpd -qg'

# Fixes weird problem in tmux and ssh with zsh-syntax-highlighting.
alias sudo='sudo '

alias sedit='sudoedit'

# Using `type` is much nicer and provides information for various layers.
alias whichall='type -a'

# Prompt if deleting more than 3 files. Todo: revisit
alias rm='rm -I'

alias human-readable='numfmt --to=iec --suffix=B'

if command_exists git; then
  alias g='git'
  alias git='noglob git'
fi

if command_exists hub; then
  eval "$(hub alias -s)"
fi

if command_exists tlmgr; then
  alias tlmgr-search-file='tlmgr search --global --file'
fi


# todo: use vim
# if command_exists vim; then
#   # Update packages.
#   alias vimup='vim +PlugInstall +qall'
# fi

if command_exists ag; then
  alias agl='ag -Q'
fi

if command_exists rg; then
  alias rgl='rg -F'
fi

if command_exists tree; then
  alias tree='tree -I .git -a'
fi

if command_exists tmux; then
  alias t='tmux'
  alias tmux='tmux -2 -u'

  alias tn='tmux new-session -s'
  alias tc='tmux new-session -t'
  alias ta='tmux attach-session -t'

  alias taro='tmux attach-session -rt'

  alias ":qa"='[[ -n $TMUX ]] && tmux confirm-before kill-session'
  alias ":wqa"='[[ -n $TMUX ]] && [[ -f ~/.tmux/plugins/tmux-resurrect/scripts/save.sh ]] && tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh && :qa'
fi

if command_exists rake; then
  # Don't interpret brackets in arguments as glob patterns.
  alias bundle='noglob bundle'
  alias rake='noglob rake'
fi

if command_exists xsel; then
  alias cbc='xsel -i -b'
  alias cbp='xsel -o -b'
elif command_exists pbcopy; then
  alias cbc='pbcopy'
  alias cbp='pbpaste'
fi

if command_exists rustup; then
  alias rsup='rustup'
  alias rsupdate='rustup update'
  alias clippy='cargo +nightly clippy'
fi

if command_exists cargo; then
  alias c='cargo'
  alias cb='cargo build'
  alias cbl='cargo build --color=always 2>&1 | less -K +F'
  alias ct='cargo test'
  alias ctl='cargo test --color=always 2>&1 | less -K +F'
  alias cup='cargo +nightly install-update -a'
fi

if command_exists systemctl; then
  alias sc='systemctl'
  alias scs='systemctl status'
  alias scr='systemctl restart'

  alias scu='systemctl --user'
  alias scus='systemctl --user status'
  alias scur='systemctl --user restart'
fi

if command_exists journalctl; then
  alias jc='journalctl'
  alias jcu='journalctl --user-unit'
fi

if command_exists kubectl; then
  alias k='kubectl'
  alias kc='kubectl'
fi
