#!/bin/bash

#
# Game list
#

#
#	Gamelist format
#	keyword*new x?*workdir*type*wineprefix*command
#
#	keyword - key parameter for game launch
#	new x? - launch game in new x?
#	workdir - game working directory
#	type - linux or windows?
#	wineprefix - path to wineprefix
#	command - game execute file with additional options
#



GAMELIST='/home/calman/.gamelaunch/gamelist'
#GAMELIST='./gamelist'
GAMESCREEN=':1'
ENVPATH=$(which env)
WINEPATH=$(which wine)
ENVP='env'

#
#	Set new x session start program (xlaunch or xinit)
#
NEWXPROG=$(which xlaunch)
if [[ -z $NEWXPROG ]]; then
	NEWX='xinit'
	ENVP=$ENVPATH
else
	NEWX='xlaunch'
fi

#
#	game keyword
#
GAME=$1

#
#	parameter string
#
GAMESTRING=$(cat $GAMELIST|grep $GAME)

#
#	New X session option
#
INNEW=$(echo $GAMESTRING|grep $GAME|cut -d"*" -f2)
#
#	Game workdir
#
WORKDIR=$(echo $GAMESTRING|grep $GAME|cut -d"*" -f3)

#
#	Wine game or native?
#
GAMETYPE=$(echo $GAMESTRING|grep $GAME|cut -d"*" -f4)

#
#	Set wineprefix
#
WINEPREF=$(echo $GAMESTRING|grep $GAME|cut -d"*" -f5)

if [[ "$GAMETYPE" == "wine" ]]; then
	if [[ "$WINEPREF" == "none" ]]; then
		if [[ $NEWX == "xinit" && $INNEW == "new" ]]; then
			LAUNCH="$WINEPATH"
		else
			LAUNCH="wine"
		fi
	else	
		LAUNCH="$ENVP WINEPREFIX=$WINEPREF wine"
	fi
else
	LAUNCH=""
fi

EXECUTE=$(echo $GAMESTRING|grep $GAME|cut -d"*" -f6)
if [[ $WORKDIR != "none" ]]; then
	cd "$WORKDIR"
fi

if [[ $NEWX == "xinit" && $INNEW == "new" ]]; then
	LAUNCH="$NEWX $LAUNCH $EXECUTE -- $GAMESCREEN"
else
	if [[ $INNEW == "new" ]]; then
		LAUNCH="$NEWX $LAUNCH $EXECUTE"
	else
		LAUNCH="$LAUNCH $EXECUTE"
	fi
fi

if [[ $INNEW == "new" ]]; then
	`$LAUNCH`
else
	`$LAUNCH`
fi


