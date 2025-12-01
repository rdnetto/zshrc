# Used by Jmake CI
export JIRA_REPO="$HOME/sources/jira"

# Load Jmake autocompletion
[ -d $HOME/.jmake ] && source $HOME/.jmake/completion/jmake.completion.zsh

# AWS CLI support
[ -d ~/sources/awscli-saml-auth ] && source $HOME/sources/awscli-saml-auth/zshrc_additions

# LaaS CLI support
[ -f /usr/share/zsh/site-functions/_laas ] && source /usr/share/zsh/site-functions/_laas

# Use jenv
if [ -d ~/.jenv/ ] ; then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi

if which podman &> /dev/null; then
    alias docker=podman
fi

# Aliases for grepping POMs / plugin.xml
alias pom-grep="git ls-files pom.xml '**/pom.xml' | xargs -r rg"
alias plugin-grep="find . -iname atlassian-plugin.xml -print0 | xargs -0 -r ag"
alias cd-migrations='cd ./jira-components/jira-core/src/main/resources/db/platform/migrations/'

# Aliases for connecting to Postgres in a docker container (started by jmake)
alias pg-docker="./jmake postgres"
alias pg-docker-restart="pg-docker stop; pg-docker start $@"
alias pg-purge='docker rm -f $(cat docker.cid)'
alias pgcli-docker="pgcli -h localhost -p 5433 jira jira"
alias pgcli-d="pgcli -h localhost -p 5433 -U jira -d "
alias psql-docker="psql -h localhost -p 5433 jira jira"
alias psql-d="psql -h localhost -p 5433 -U jira -d "
alias pgcli-sis='pgcli -h localhost -p 5435 postgres postgres'
alias docker-cleanup='docker rm $(docker ps -a | awk "/Exited/{print $1}")'
alias mci='mvn clean install -DskipTests'
alias mcp='mvn clean package -DskipTests'
alias am='atlas micros'
alias aml='atlas micros login -u rdnetto'
alias an='atlas nebulae'
alias adr='atlas devenv remote'
alias dc='docker compose'
alias tf='terraform'

alias jmake_alpha='export JMAKE_VERSION=$(xpath -q -e "/project/version/text()" ~/sources/jmake/pom.xml)'

# go/build-status-in-a-shell
alias builds='$HOME/sources/build-status-in-a-shell/cli/build-status.py --list'

function am_ssh() {
    echo "Retrieving instance ID"
    instance="$(atlas micros compute show -s $1 -e ddev -o json | jq -r '.WebServer.Instances[0].InstanceID')"
    echo "Connecting"
    atlas micros compute ssh -s "$1" -e ddev -i "$instance"
}

function bamboo_creds() {
    CON=/etc/NetworkManager/system-connections/Charlie
    export BAMBOO_USERNAME=$(sudo awk -F= '($1 == "identity"){print $2}' $CON)
    export BAMBOO_PASSWORD=$(sudo awk -F= '($1 == "password"){print $2}' $CON)
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

function get_network-segment() {
    atlas slauth curl -a cna-mns-mat -e prod -- "https://cna-mns-mat.ap-southeast-2.prod.atl-paas.net/api/v1/get_current_segment/$1" | jq .
}
