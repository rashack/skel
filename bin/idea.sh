#!/bin/bash

IDEA_INSTALLATIONS=$HOME/Downloads

LATEST=$(ls -1d $IDEA_INSTALLATIONS/idea-IU* | tail -1)

IDEA=$LATEST/bin/idea.sh
echo "Staring InjtelliJ IDEA: $IDEA"
exec $IDEA
