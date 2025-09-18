ZSH=$HOME/.zsh

new_path=""
for dir (
    # Local binaries
    $HOME/.local/bin
    $HOME/bin
    $HOME/.cargo/bin

    # Android SDK path
    $HOME/bin/android-sdk-linux/platform-tools

    # Homebrew
    /opt/homebrew/bin

    # Prefer GNU impls on OSX
    /opt/homebrew/opt/coreutils/libexec/gnubin
    /opt/homebrew/opt/findutils/libexec/gnubin
    /opt/homebrew/opt/gawk/libexec/gnubin
    /opt/homebrew/opt/grep/libexec/gnubin
    /opt/homebrew/opt/gnu-sed/libexec/gnubin
    /opt/homebrew/opt/gnu-tar/libexec/gnubin
    /opt/homebrew/opt/util-linux/bin
    /opt/homebrew/opt/util-linux/sbin

    # Misc
    $HOME/.jenv/bin
    $HOME/.jsync/bin
); do
    if [ -d "$dir" ]; then
        new_path="$new_path:$dir"
    fi
done

export PATH="$new_path:$PATH"
unset new_path

# Misc setup
[ ! -d ~/.jenv/ ] || eval "$(jenv init -)"
[ ! -f /opt/homebrew/bin/brew ] || eval "$(/opt/homebrew/bin/brew shellenv)"

# Environment
export EDITOR="nvim"
export VISUAL="nvim"
TERMINAL=$(which kitty)

# Fix for broken ls behaviour
QUOTING_STYLE=literal

# This fixes xdg-open
export KDE_SESSION_VERSION=5

# Make zsh-you-should-use only show the longest matching alias
YSU_MODE=BESTMATCH

#Force 256 colour support (needed for tmux)
 [[ "$TERM" == "xterm" ]] && export TERM="xterm-256color"

# Set SWAYSOCK if unset
if [[ -z "${SWAYSOCK-}" ]] && pgrep -x sway >/dev/null ; then
    export SWAYSOCK="/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock"
fi

# Set MAKEOPTS intelligently, so that we use the appropriate number of cores.
# We use both -j and -l to handle 
if which lscpu &>/dev/null ; then
    CPU_COUNT="$(lscpu -p | grep -cv '^#')"
    export MAKEOPTS="-j ${CPU_COUNT} -l ${CPU_COUNT}"
fi

# Used in sway config for host-specific configuration
export HOST="$(hostname)"

export STAFF_ID=rdnetto
export ATLAS_USER=rdnetto
# Stop the RDEs from replacing my prompt
export DISABLE_ZSH_DEFAULT_PROMPT=true
