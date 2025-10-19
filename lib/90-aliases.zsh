# Basic directory operations
alias ..='cd ..'
alias ...='cd ../..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

alias rm="rm -v --one-file-system"
alias rmq='\rm -rf --one-file-system'
alias cp="cp --reflink=auto"

# Cat aliases
if (cmd_exists bat) ; then
    alias c=bat
# Debian-based systems
elif (cmd_exists batcat) ; then
    alias c=batcat
else
    alias c=cat
fi

alias tcat="tail -n +0"

# List direcory contents
alias sl=ls
alias ll='ls -lh'
alias la='ls -A'

# Misc commands
if [ "$(uname -o)" = "Darwin" ]; then
    alias x='open'
else
    alias x='xdg-open'
fi

alias lsblk='lsblk -o NAME,MAJ:MIN,SIZE,RO,TYPE,FSTYPE,UUID,MOUNTPOINT'
alias rgrep='grep -rn --exclude-dir=.git'
alias rg="rg --smart-case                \
             --colors line:fg:yellow     \
             --colors line:style:bold    \
             --colors path:fg:green      \
             --colors path:style:bold    \
             --colors match:fg:black     \
             --colors match:bg:yellow    \
             --colors match:style:nobold "
alias ag=rg
alias agQ='rg -F'
alias agJ='rg -t java'
alias agH='rg -t haskell'
alias iotop='sudo iotop -o'
alias mtr='mtr --curses --displaymode 2'
alias dmesg='dmesg -H'
alias dot-update='for i in ~/.vim ~/.zsh ~/.config ; do test -d $i && git -C $i pull && git -C $i submodule update; done'
alias parallel='parallel --will-cite'
alias ip='ip -c'
alias shutup_and_take_my_memory='prlimit -vunlimited'
alias virsh='virsh --connect qemu:///system'
alias mpv='mpv --no-audio-display'
alias jmtpfs='echo "Just use adb, its 40x faster"; false'
alias android_vnc=scrcpy

# Support using Kitty with systems that don't have the terminfo installed, but only if stdin is a tty
function ssh() {
    # Prevent OSX from disrupting the session
    if which caffeinate &>/dev/null ; then
        CAF=(caffeinate -i)
    else
        CAF=()
    fi

    if [ -t 0 ] && [ "$TERM" = "xterm-kitty" ] && which kitty >/dev/null ; then
        $CAF kitty +kitten ssh "$@"
    else
        $CAF ssh "$@"
    fi
}

# Stack aliases
alias sb='nice stack build'
alias sdb='nice stack --docker build'
alias sbf='nice stack build --fast'
alias sbt='nice stack test --no-run-tests'
alias sbft='nice stack test --fast'
alias st='nice stack test'
alias hoogle='nice ionice -c3 stack hoogle -- server --local -p 60080'

# Cargo aliases
alias cb='cargo build'
alias cr='cargo run'
alias cD='cargo doc --workspace --open'

# Needed for tmux <3.1 - https://github.com/tmux/tmux/issues/142
alias tmux='tmux -f ~/.config/tmux/tmux.conf'

# Vim aliases
alias v="nvim"
alias qv="nvim-qt"
alias qvdiff="nvim-qt $@ -- -d"

# Git aliases
alias t=tig
alias dm=dispatch-merge
alias gfzf='git ls-files | fzf'

alias g='git'
alias gs='git status'
alias gp='git push'
alias gpu='git push -u'
alias gpf='git push --force-with-lease'
alias gr='git remote'
alias gf='git fetch'
alias gft='git fetch --tags'
alias gpl='git pull --prune'
alias gplr='git pull --prune --rebase'
alias gplm='git checkout master && git pull --prune && git checkout -'
alias ga='git add'
alias gap='git add -p'
alias gsh='git show'
alias gcl='git clone --recursive'
alias groot='cd $(git rev-parse --show-toplevel || echo ".")'
alias gw='git worktree'

alias gbi='git bisect'
alias gbb='git bisect bad'
alias gbg='git bisect good'

alias gb='git branch'
alias gba='git branch -a'

alias gco='git checkout'
alias gcom='git checkout master'
alias gcop='git checkout -p'

alias gc='git commit -v'
alias gcp='git commit -pv'
alias gcq='git commit'
alias gc!='git commit --no-edit'
alias gcA='git commit --amend -v'
alias gcA!='git commit --amend -C HEAD'
alias gca='git commit -v -a'
alias gcaA='git commit -a --amend -v'
alias gcaA!='git commit -a --amend -C HEAD'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcf='git commit --fixup'

alias gd='git diff'
alias gdc='git diff --cached'
alias gdm='git diff master'
alias gdr='git diff root'
alias gdn='git diff --no-index --color=always'
alias gdnw='git diff --no-index --color-words'
alias gdw='git diff --color-words'
alias gdx='git diff --color-words=.'

alias gl='git log'
alias glp='git log -p'
alias git-graph='git log --graph --oneline --decorate'
alias gl-authors="git log --pretty=format:'%h %<(20)%an %<(40)%ae %s'"

alias gm='git merge'
alias gma='git merge --abort'
alias gmt='git mergetool --no-prompt'
alias gmm='git merge master --no-edit'

alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grbs='git rebase --skip'
alias grb-show-current='git show $(cat "$(g rev-parse --git-dir)/rebase-apply/original-commit")'

alias grs='git reset --soft'
alias grm='git reset --mixed'
alias grh='git reset --hard'

alias gs='git status'
alias gss='git status -s'

function gfco() {
    git fetch origin "$1"
    git checkout "$1"
}

function gb-set-upstream() {
    git branch --set-upstream-to="origin/$1" "$1"
}

function gb-default-upstream() {
    BRANCH="$(git symbolic-ref --short HEAD)"
    git branch --set-upstream-to="origin/$BRANCH" $BRANCH
}

function git-merge-containing() {
    # assuming HEAD is master
    git rev-list --merges --ancestry-path --format="%H %P" $1..HEAD | tac | while read -r merge parent1 parent2; do
        if [ "$parent2" != "" ]; then
            if git merge-base --is-ancestor $1 $merge && ! git merge-base --is-ancestor $1 $parent1; then
                echo "$merge"
                break
            fi
        fi
    done
}

# Aliases for screen sharing in Wayland
function enable_xwayland_screen_sharing() {
    OUTPUT="$(swaymsg -t get_outputs | jq -r '.[] | select(.model == "C27HG7x") | select (.active) | .name')"
    wf-recorder --muxer=sdl --codec=rawvideo --file=pipe:mirror --output="$OUTPUT" "$@"
}

function enable_v4l_screen_sharing() {
    V4L_DEV="/dev/$(find /sys/devices/virtual/video4linux/ -maxdepth 1 -mindepth 1 -printf '%f\n' | head -n1)"
    OUTPUT="$(swaymsg -t get_outputs | jq -r '.[] | select(.model == "C27HG7x") | select (.active) | .name')"
    wf-recorder --muxer=v4l2 --codec=rawvideo --pixel-format=yuv420p --file="$V4L_DEV" --output="$OUTPUT" "$@"
}

