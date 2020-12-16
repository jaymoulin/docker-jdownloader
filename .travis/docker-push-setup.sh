#!/usr/bin/env bash

#https://graysonkoonce.com/getting-the-current-branch-name-during-a-pull-request-in-travis-ci
export BRANCH=$(if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then echo $TRAVIS_BRANCH; else echo $TRAVIS_PULL_REQUEST_BRANCH; fi)

if [ "$BRANCH" == "master" ] || [ "$BRANCH" == "main" ]; then
    echo "This commit has been merged to master so on success images will be pushed"
    export SHOULD_DOCKER_PUSH=true
    export TAGS=latest
else
    if [ "$BRANCH" == "devel" ]; then
        export SHOULD_DOCKER_PUSH=true
        export TAGS=devel
    else
    echo "This is branch: $BRANCH so we won't be pushing"
    fi
fi

if [ "$SHOULD_DOCKER_PUSH" = true ]; then
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
fi

DOCKER_BASE=${DOCKER_USER}/$(echo ${TRAVIS_REPO_SLUG} | cut -d'/' -f2)
