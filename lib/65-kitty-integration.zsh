# This needs to be sourced after the prompt has been configured by starship
# Taken from https://sw.kovidgoyal.net/kitty/shell-integration/#manual-shell-integration

if [ -n "$KITTY_INSTALLATION_DIR" ]; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi
