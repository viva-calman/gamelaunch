#!/bin/bash

#
# Game list
#

#GAMELIST='~/.gamelaunch/gamelist'
GAMELIST='./gamelist'

GAME=$1

WORKDIR=$(cat $GAMELIST|grep $GAME|cut -d"*" -f2)
LAUNCH=$(cat $GAMELIST|grep $GAME|cut -d"*" -f3)
cd $WORKDIR

echo $WORKDIR $LAUNCH

