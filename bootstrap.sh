#!/usr/bin/env bash

git config --global user.name ${GIT_USER_NAME:-"stakater-user"}

git config --global user.email ${GIT_USER_EMAIL:-"stakater@gmail.com"}

mkdir -p /root/.ssh/

ssh-keyscan github.com > /root/.ssh/known_hosts

exec $@