typeset -U path

export GOPATH=${HOME}/code/gopath

export NODE_PATH=/usr/local/lib/node_modules:$NODE_PATH

if command_exists rustc; then
  RUST_SYSROOT=$(rustc --print sysroot)

  # rustup component add rust-src
  export RUST_SRC_PATH=${RUST_SYSROOT}/lib/rustlib/src/rust/src

  # rust libraries
  export LD_LIBRARY_PATH=${RUST_SYSROOT}/lib:$LD_LIBRARY_PATH
fi

mkdir -p ~/bin

export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"

path=(
  ~/bin

  ${GOPATH}/bin
  ~/.local/bin
  ~/.cargo/bin
  ~/.cabal/bin

  ~/Library/Application\ Support/JetBrains/Toolbox/scripts

  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

  "$path[@]"
)

# prune paths that don't exist
path=($^path(N))

manpath=(
  /usr/local/share/man

  "$manpath[@]"
)

manpath=($^manpath(N))

infopath=(
  /usr/local/share/info
  "$infopath[@]"
)

infopath=($^infopath(N))

# To create a custom array-to-envvar link:
# typeset -aU env_var
# typeset -T ENV_VAR env_var ' ' # Colon by default.
# export ENV_VAR

# env_var=(
#   # …
#   "$env_var[@]"
# )
