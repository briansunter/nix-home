# settings
## Terminal Vim Mode
export KEYTIMEOUT=1
bindkey -v

# aliases
alias ec='emacsclient -c'
alias ds='darwin-rebuild switch'
alias simple-serve='python -m SimpleHTTPServer 8000'
# antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

export PATH=$PATH:$GOPATH/bin

# FZF
## fd - cd to selected directory
fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
      -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$dir"
}
fe() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}
vf() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && nvim "${files[@]}"
}

# fasd init
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
    fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
