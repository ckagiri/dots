#############################################
# linux.zsh – Linux specific interactive setup
#############################################

[[ -z "$IS_LINUX" ]] && return 0

# Abort early for non-interactive shells.
[[ -o interactive ]] || return 0

# Ensure we have a reliable command_exists (defined in dot_zshrc normally)
command_exists() { (( $+commands[$1] )) }

# Optional lightweight hints for useful CLI tools (no installer).
# Comment this block out if you want a completely silent login.
for tool in batcat btop duf eza fzf rg zoxide; do
  command_exists "$tool" || echo "[linux.zsh] $tool (Ubuntu binary) is missing; install the corresponding package from your distro." >&2
done

typeset -a linux_manual_tools
linux_manual_tools=(
  broot    # install via script/cargo
  dust     # snap install dust or cargo
  procs    # snap install procs or cargo
  starship # starship.rs install script
  sd       # https://github.com/chmln/sd
)

for tool in ${linux_manual_tools[@]}; do
  if ! command_exists "$tool"; then
    case "$tool" in
      dust)
        echo "[linux.zsh] dust missing – e.g.: sudo snap install dust" >&2 ;;
      procs)
        echo "[linux.zsh] procs missing – e.g.: sudo snap install procs" >&2 ;;
      starship)
        echo "[linux.zsh] starship missing – see https://starship.rs" >&2 ;;
      broot)
        echo "[linux.zsh] broot missing – see https://dystroy.org/broot" >&2 ;;
      sd)
        echo "[linux.zsh] sd missing – see https://github.com/chmln/sd" >&2 ;;
    esac
  fi
done

# Clipboard integration (Wayland/X11).
if command_exists wl-copy && command_exists wl-paste; then
  alias cbc='wl-copy'
  alias cbp='wl-paste'
elif command_exists xclip; then
  alias cbc='xclip -selection clipboard'
  alias cbp='xclip -selection clipboard -o'
elif command_exists xsel; then
  alias cbc='xsel -i -b'
  alias cbp='xsel -o -b'
fi

# fd-find package installs binary as 'fdfind' (Ubuntu). Provide 'fd' alias if needed.
if command_exists fdfind && ! command_exists fd; then
  alias fd='fdfind'
fi

# Pager / man integration: prefer bat if available.
if command_exists bat; then
  export MANPAGER='sh -c "col -bx | bat -l man -p"'
elif command_exists less; then
  export MANPAGER='less -R'
fi

# Set LS_COLORS if not already set (GNU dircolors style). Only if dircolors present.
if [[ -z "$LS_COLORS" ]] && command_exists dircolors; then
  if [[ -f $HOME/.dircolors ]]; then
    eval "$(dircolors -b $HOME/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# Prefer colorized grep, etc.
if command_exists grep; then alias grep='grep --color=auto'; fi
if command_exists diff; then alias diff='diff --color=auto'; fi

# Systemd convenience (only if not already defined in alias.zsh; harmless if duplicate)
if command_exists systemctl; then
  alias sc='systemctl'
  alias scu='systemctl --user'
fi

# Ubuntu-specific compatibility aliases
if command_exists batcat && ! command_exists bat; then
  alias bat='batcat'
fi

if command_exists rg && ! command_exists ripgrep; then
  alias ripgrep='rg'
fi

# Path sanity: If linuxbrew added earlier ensure its man/info if present.
for extra_man in /home/linuxbrew/.linuxbrew/share/man; do
  [[ -d $extra_man ]] && manpath+="$extra_man"
done
for extra_info in /home/linuxbrew/.linuxbrew/share/info; do
  [[ -d $extra_info ]] && infopath+="$extra_info"
done

# Cleanup duplicates
typeset -U manpath infopath

return 0
