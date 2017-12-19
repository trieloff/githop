#!/bin/zsh
BRANCH=$(git branch | grep "*" | sed -e "s/..//")
URL=$(git config remote.$(git config branch.$BRANCH.remote).url)

echo $URL | grep github.com &> /dev/null
if [ $? -eq 0 ]; then
  VERSIONCONTROL=github
  OWNER=$(echo $URL | sed -e "s/.*://" | sed -e "s|/.*||")
  PROJECT=$(echo $URL | sed -e "s|.*/||" | sed -e "s|\..*||")
  STATUS=$(curl https://circleci.com/api/v1.1/project/$VERSIONCONTROL/$OWNER/$PROJECT/tree/$BRANCH\?limit\=1  2> /dev/null | jq -r ".[0].failed" 2> /dev/null)
  if [ "$STATUS" = "null" ]; then
    echo ⚪
  elif [ "$STATUS" = "false" ]; then
    echo ✅ 
  elif [ "$STATUS" = "true" ]; then
    echo 🔴 
  else
    echo ⚫️
  fi
fi