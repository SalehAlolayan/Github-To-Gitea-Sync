#!/bin/bash
#Syncing user X repos to your Gitea instent
#An Improved version from https://dev.to/nicolasboyer/migrate-all-of-your-repos-from-github-to-gitea-3fk

GITHUB_USERNAME=
GITHUB_TOKEN=

GITEA_USERNAME=
GITEA_TOKEN=
GITEA_DOMAIN=
GITEA_REPO_OWNER=


GET_REPOS=$(curl -H 'Accept: application/vnd.github.v3+json' -u $GITHUB_USERNAME:$GITHUB_TOKEN -s "https://api.github.com/users/$GITHUB_USERNAME/repos?per_page=200&type=all" | jq -r '.[].html_url')

for URL in $GET_REPOS; do

    REPO_NAME=$(echo $URL | sed "s|https://github.com/$GITHUB_USERNAME/||gI")

    echo "Found $REPO_NAME, importing..."

    curl -X POST "https://$GITEA_DOMAIN/api/v1/repos/migrate" -H "Authorization: token $GITEA_TOKEN" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \
    \"auth_username\": \"$GITHUB_USERNAME\", \
    \"auth_password\": \"$GITHUB_TOKEN\", \
    \"clone_addr\": \"$URL\", \
    \"mirror\": true, \
    \"private\": false, \
    \"repo_name\": \"$REPO_NAME\", \
    \"repo_owner\": \"$GITEA_REPO_OWNER\", \
    \"service\": \"git\", \
    \"uid\": 0, \
    \"wiki\": true}"

done
