function take() {
  mkdir -p $1
  cd $1
}

function fv(){
    # Function for selecting a file with fzf & opening it in $EDITOR

    # Use git for listing files if possible, for performance and convenience
    # git ls-files is fast but only shows tracked files, so use `git clean -n` to get untracked files
    # This is faster to show the files we're more likely to care about than a single command
    if git rev-parse --git-dir &>/dev/null ; then
        $EDITOR "$(env FZF_DEFAULT_COMMAND="git ls-files; git clean -n | sed 's/^Would remove //'" fzf)"
    else
        $EDITOR "$(fzf)"
    fi
}

function gcof(){
    # Function for selecting with fzf a red and checking it out
    SELECTION=$(git show-ref | sed 's|refs/||' | fzf)
    HASH=$(echo "$SELECTION" | awk '{print $1}')
    REF=$(echo "$SELECTION"  | awk '{print $2}')
    REF_TYPE=$(echo "$REF"   | cut -d/ -f1)
    REF_NAME=$(echo "$REF"   | cut -d/ -f2-)

    if [[ "$REF_TYPE" == "remotes" ]] ; then
        # Remote branch - need to explicitly setup tracking
        # e.g. origin/issue/JDEV-XXXX-foo
        REMOTE=$(echo "$REF" | cut -d/ -f2)
        BRANCH=$(echo "$REF" | cut -d/ -f3-)

        echo "$BRANCH, $REF_NAME, $REMOTE"
        git checkout -b "$BRANCH" "$HASH"
        git config --local --add branch."$BRANCH".remote "$REMOTE"
        git config --local --add branch."$BRANCH".merge refs/heads/$BRANCH

    elif [[ "$REF_TYPE" == "heads" ]]; then
        git checkout "$REF_NAME"

    elif [[ "$REF_TYPE" == "tags" ]]; then
        git checkout -b "$REF_NAME" "$HASH"

    else
        echo "Unknown ref type: $REF_TYPE" >&2
        exit 1
    fi
}

function new-agent() {
    # Skip printing agent PID when sourcing
    ssh-agent | grep -v ^echo > /tmp/.ssh-agent
    source /tmp/.ssh-agent
    ssh-add ~/.ssh/id_rsa
}

