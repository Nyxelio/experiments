#!/bin/bash

#------------------------------------------------------------------------------
#
# Author: Nyxelio
#
# Description: Manage keyboard leds for a notification or an alarm. Support blinking for ScrollLed, CapslockLed and NumlockLed.
# 
# Year: 2008
#
#------------------------------------------------------------------------------

# LockFile. Lock led to avoid concurrent jobs.
lockFile="/tmp/lock-LedControlEngine-`whoami`"

# Led id may change depending on your hardware configuration. Usually, values are 1, 2 or 3 for main leds but may reach as high as 32 (man xset).
targetLed=3

#Count of blinking. Set 1 for a fixed lighting:
blinkingCount=3

#Delays:
lightedLedDelay=0.3s
unlightedLedDelay=0.3s

#Sequence repetition. Set 1 for a sequence without repetition:
sequenceCount=2

#Sequence interval:
sequenceInterval=0.5s


if [ $# -ne 0 ]
then
	if [ $1 == "-h" ]
	then
		echo -e "Usage: $0 [BlinkingCount SequenceCount]\n\nblinkingCount: Count of blinking\n\nSequenceCount: Sequence repetition\n\nManage keyboard leds for a notification or an alarm. Support blinking for ScrollLed, CapslockLed and NumlockLed."
		
		exit 0
	else	

		blinkingCount=$1
		sequenceCount=$2

	fi
fi

if [ ! -e $lockFile ]
then
	touch $lockFile

	for i in `seq 1 $sequenceCount`
	do
		for j in `seq 1 $blinkingCount`
		do
			xset led $targetLed
			sleep $lightedLedDelay
			
			xset -led $targetLed
			sleep $unlightedLedDelay
		done
	
		sleep $sequenceInterval
	done


	#Set targetLed on known state:
	xset -led $targetLed

	#Remove lockfile:
	rm $lockFile
fi
