#!/bin/bash

projects="Dockerfile java.Dockerfile clojure.Dockerfile clojurescript.Dockerfile node.Dockerfile erlang.Dockerfile elixir.Dockerfile haskell.Dockerfile rust.Dockerfile"

if [ ! -z "$1" ]; then
  projects=$1
  echo $projects
fi

echo "Building $projects"

for project in $projects; do
  if [[ "$project" == Dockerfile ]];then
    docker build -t githop -f $project .
    docker tag githop trieloff/githop:latest
    docker push trieloff/githop:latest
  else
    docker build -t githop:$(echo $project | sed -e "s/\\..*//") -f $project .
    docker tag githop:$(echo $project | sed -e "s/\\..*//") trieloff/githop:$(echo $project | sed -e "s/\\..*//")
    docker push trieloff/githop:$(echo $project | sed -e "s/\\..*//")
  fi
done