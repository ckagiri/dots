# open man page and jump to specific option
# $ manf ls -l
manf() {
  man -P "less -p \"^( +\K$2| +-[^ ]+( or|,) \K$2)\"" $1
}

cheat() {
  curl "cht.sh/${1}"
}

# open man page and jump to examples section
eg() {
  man -P "less -p \"^EXAMPLES?\"" $1
}

# create a directory and cd into it
mkcd() {
  mkdir $1 && cd $_
}

# run emacs in a new session
# this way closing the shell it was started from won't
# kill emacs, nor will it usurp the shell
e() {
  if [[ "$OSTYPE" == darwin* ]]; then
    emacs $* > /dev/null 2>&1 &!
  else
    ( setsid emacs $* > /dev/null 2>&1 & );
  fi
}

# html man pages
manh() {
  file=$(mktemp)
  man --html=cat $1 > $file 2>/dev/null

  if [[ -s $file ]]; then
    $BROWSER $file 2>/dev/null
  else
    echo "no man page for '$1'"
  fi
}

# find the zsh file that backs a command
# $ funcpath ls
# /usr/share/zsh/functions/Completion/Unix/_ls
funcpath() {
  echo ${^fpath}/_${1}(N)
}

# label the current window/tab
label() {
  print -Pn "\e]2;$1\a"
}

# serve an application with vnc
streamapp() {
  x11vnc -id pick -display :0 -passwd $1 -viewonly -shared -forever
}

# print colors
# $ clist 16
clist(){
  x=`tput op`
  y=`printf %76s`
  for i in {0..$1}
  do
    o=00$i
    echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x
  done
}

# print numerical permissions before each item in ls
lsp() {
  command ls -lh --time-style '+%m/%d/%y %I:%M %p' --color=always $@ |\
    awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)\
         *2^(8-i));if(k)printf("%0o ",k);print}'
}

# enter a docker container
dexec() {
  docker exec -it "${1}" "${2:-bash}"
}

drun() {
  docker run --rm -it "${1}" "${2:-bash}"
}

klogs() {
  kubectl logs -n "$1" -c "$2" "$3"
}

# $ ip get
#   copied <ip> to clipboard
ip() {
  emulate -LR zsh

  if [[ $1 == 'get' ]]; then
    res=$(curl -s ipinfo.io/ip)
    echo -n $res | xsel --clipboard
    echo "copied $res to clipboard"
  # only run ip if it exists
  elif (( $+commands[ip] )); then
    command ip $*
  fi
}

# open alias for xdg-open
# it ignores stdout and stderr
if (( $+commands[xdg-open] )); then
  open() {
    emulate -LR zsh

    xdg-open $* > /dev/null 2>&1
  }
fi

# Inspiration: https://github.com/petertriho/dotfiles/blob/main/scripts/.local/bin/update
update_plugins() {
  echo "updating zsh plugins"
  zinit update

  echo "updating tmux plugins"
  ~/.tmux/plugins/tpm/bin/update_plugins all

  # Reload tmux configuration if there are running sessions. Note that this
  # simply "overlays" the new configuration over the previously loaded one,
  # meaning for example that key binds that were removed in a newer
  # configuration version will remain in the running session until it's
  # restarted.
  #
  # It's possible to unbind all binds with `unbind -a` and then load a "clean
  # slate" configuration of out-of-the-box tmux binds which can be retrieved
  # using:
  #
  # $ tmux -f /dev/null -L temp start-server \; list-keys
  #
  # See https://unix.stackexchange.com/questions/57641
  if tmux info &> /dev/null; then
    tmux source-file ~/.tmux.conf \; display "Reloaded!"
  fi

  brew update
  brew upgrade
}

# deploy the dotfiles
install_plugins() {
  echo "installing tmux plugins"
  ~/.tmux/plugins/tpm/bin/install_plugins
}
