#!/bin/zsh

for project in *Dockerfile; do
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