# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
eval -- "$(/home/linuxbrew/.linuxbrew/bin/starship init bash --print-full-init)"

if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

if command -v zoxide &> /dev/null; then
  alias cd="zd"
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      if ! z "$@"; then
        echo "Error: Directory not found"
        return 1
      fi

      printf "\U000F17A9 "
      pwd
    fi
  }
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ff="fzf --preview 'case \$(file --mime-type -b {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES}@0x0 {} ;; *) bat --style=numbers --color=always {} ;; esac'"
else
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
fi
alias eff='$EDITOR "$(ff)"'
sff() { if [ $# -eq 0 ]; then echo "Usage: sff <destination> (e.g. sff host:/tmp/)"; return 1; fi; local file; file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) && [ -n "$file" ] && scp "$file" "$1"; }

# Podman containers (dots repo)
COMPOSE_HERMES="$HOME/git/personal/dots/containers/hermes/docker-compose.hermes.yml"
COMPOSE_LLAMA="$HOME/git/personal/dots/containers/ai/docker-compose.llama.yml"

alias chs="podman compose -f $COMPOSE_HERMES up -d"
alias chd="podman compose -f $COMPOSE_HERMES down"
alias cls="podman compose -f $COMPOSE_LLAMA up -d"
alias cld="podman compose -f $COMPOSE_LLAMA down"
alias cas="podman compose -f $COMPOSE_HERMES up -d && podman compose -f $COMPOSE_LLAMA up -d"
alias cad="podman compose -f $COMPOSE_HERMES down && podman compose -f $COMPOSE_LLAMA down"
alias clh="podman compose -f $COMPOSE_HERMES logs -f"
alias cll="podman compose -f $COMPOSE_LLAMA logs -f"
alias crh="podman compose -f $COMPOSE_HERMES build --no-cache"
alias crl="podman compose -f $COMPOSE_LLAMA build --no-cache"

unset rc COMPOSE_HERMES COMPOSE_LLAMA
