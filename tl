#!/bin/sh

T=~/.gtimelog/timelog.txt

if [ -z "$*" ]
then
	tail $T
else
	echo "`date "+%F %R"`: $*" >> $T
fi

