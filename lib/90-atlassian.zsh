# Used by Jmake CI
export JIRA_REPO="$HOME/sources/jira"

if which podman &> /dev/null; then
    alias docker=podman
fi

# Simple aliases
alias adr='atlas devenv remote'
alias am='atlas micros'
alias aml='atlas micros login -u rdnetto'
alias an='atlas nebulae'
alias dc='docker compose'
alias mci='mvn clean install -DskipTests'
alias mcp='mvn clean package -DskipTests'

# Helpers
alias andc='docker compose -p "$(docker compose ls --format json | jq -r "map(select(.ConfigFiles | test(\"nebulae\")))[0].Name")"'
alias docker-cleanup='docker rm $(docker ps -a | awk "/Exited/{print $1}")'
alias jmake_alpha='export JMAKE_VERSION=$(xpath -q -e "/project/version/text()" ~/sources/jmake/pom.xml)'
alias pom-grep="git ls-files pom.xml '**/pom.xml' | xargs -r rg"

# Functions
#
function am_ssh() {
    echo "Retrieving instance ID"
    instance="$(atlas micros compute show -s $1 -e ddev -o json | jq -r '.WebServer.Instances[0].InstanceID')"
    echo "Connecting"
    atlas micros compute ssh -s "$1" -e ddev -i "$instance"
}

function bbp() {
    branch="$(git rev-parse --abbrev-ref HEAD)"
    encoded_branch="$(python3 -c "import urllib.parse; print(urllib.parse.quote('$branch', safe=''))")"

    remote="$(git remote get-url origin | sed 's|^ssh://||' | sed 's|:|/|')"
    workspace="$(echo "$remote" | cut -d/ -f2)"
    repo="$(echo "$remote" | cut -d/ -f3 | sed 's/\.git$//')"

    echo "https://bitbucket.org/$workspace/$repo/pipelines/results/branch/$encoded_branch/page/1"
    open "https://bitbucket.org/$workspace/$repo/pipelines/results/branch/$encoded_branch/page/1"
}
