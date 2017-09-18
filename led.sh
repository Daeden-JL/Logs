#!/bin/bash

#This script will change the led status for testing.

#Define colors
RED="led level=255,0,0 test"
BLUE="led level=0,0,255 test"
GREEN="led level=0,255,0 test"
PURPLE="led level=255,0,255 test"
YELLOW="led level=128,255,255 test"
WHITE="led level=255,255,255 test"
ORANGE="led level=255,255,0 test"

#Enable job control
set -m

# Define options.
OPTIND=1	# Reset in case getopts has been used previously in the shell.
COLOR="0"	# Return the color to auto.
TYPE="on"	# Defaults to non flashing.
IOM="0"		# IOM is not changed.
FM="1"		# FM is the default.

while getopts :IAhrgbpywofBRX opt; do
    case $opt in
		h) exit 0;;
		I) IOM="1"; FM="0";;
		A) IOM="1"; FM="1";;
		r) COLOR="$RED";;
		g) COLOR="$GREEN";;
		b) COLOR="$BLUE";;
		p) COLOR="$PURPLE";;
		y) COLOR="$YELLOW";;
		w) COLOR="$WHITE";;
		o) COLOR="$ORANGE";;
		f) TYPE="fade";;
		B) TYPE="blink";;
		R) COLOR="rainbow"; TYPE="rainbow";;
		X) TEST="X"; TYPE="fade";;
		?) exit 0;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ "$TEST" = "X" ]
	then
	COLOR="led level=$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )) test"
fi


if [ "$FM" = "1" ]
	then
	if [ "$COLOR" = "0" ]
		then
			echo "Resetting color to default."
			for i in {0..35}
			do
			umagneto -d fm$i -m <<< "led auto 0" &
			umagneto -d fm$i -m <<< "led auto 1" &
			done
			for i in {6..53}
			do
			umagneto -d iom0 -m <<< "led auto $i" &
			umagneto -d iom1 -m <<< "led auto $i" &
			done
		else
			echo "Changing color to $COLOR."
			#Set Color
			for i in {0..35}
			do
				if [ "$TYPE" = "rainbow" ]
					then
					case $(( ( RANDOM % 6 ) )) in
						0) COLOR="$RED";;
						1) COLOR="$GREEN";;
						2) COLOR="$BLUE";;
						3) COLOR="$PURPLE";;
						4) COLOR="$WHITE";;
						5) COLOR="$ORANGE";;
					esac
					if [ "$TEST" = "X" ]
						then
						COLOR="led level=$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )) test"
					fi
					umagneto -d fm$i -m <<< $COLOR &
					umagneto -d fm$i -m <<< "led state=test 0" &
					umagneto -d fm$i -m <<< "led state=test 1" &
				else
					if [ "$TEST" = "X" ]
						then
						COLOR="led level=$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )) test"
					fi
					umagneto -d fm$i -m <<< $COLOR &
					umagneto -d fm$i -m <<< "led state=test 0" &
					umagneto -d fm$i -m <<< "led state=test 1" &
				fi

			if [ "$TYPE" = "blink" ]
	                        then
	                        umagneto -d fm$i -m <<< "led $TYPE=$(( ( RANDOM % 17 )  + 1 )) test" &
	                        else if [ "$TYPE" = "work" ]
	                                then
	                                umagneto -d fm$i -m <<< "led blink=$( expr $i % 18 ) test" &
	                                else
	                                umagneto -d fm$i -m <<< "led $TYPE test" &
	                        fi
	                fi
			done
	fi
fi
echo ""
echo "Done!"
if [ "$IOM" = "1" ]
	then
		echo "Changing color to $COLOR."
		#Check for rainbow
		if [ "$TYPE" = "rainbow" ]
			then
			case $(( ( RANDOM % 6 ) )) in
				0) COLOR="$RED";;
				1) COLOR="$GREEN";;
				2) COLOR="$BLUE";;
				3) COLOR="$PURPLE";;
				4) COLOR="$WHITE";;
				5) COLOR="$ORANGE";;
			esac
			if [ "$TEST" = "X" ]
				then
				COLOR="led level=$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )) test"
			fi
			umagneto -d iom0 -m <<< $COLOR
			case $(( ( RANDOM % 6 ) )) in
				0) COLOR="$RED";;
				1) COLOR="$GREEN";;
				2) COLOR="$BLUE";;
				3) COLOR="$PURPLE";;
				4) COLOR="$WHITE";;
				5) COLOR="$ORANGE";;
			esac
			if [ "$TEST" = "X" ]
				then
				COLOR="led level=$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )) test"
			fi
			umagneto -d iom1 -m <<< $COLOR
			umagneto -d iom0 -m <<< "led blink=$(( ( RANDOM % 17 )  + 1 )) test"
			umagneto -d iom1 -m <<< "led blink=$(( ( RANDOM % 17 )  + 1 )) test"
		else
			if [ "$TEST" = "X" ]
				then
				COLOR="led level=$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )) test"
			fi
			umagneto -d iom0 -m <<< $COLOR
			if [ "$TEST" = "X" ]
				then
				COLOR="led level=$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )),$(( ( RANDOM % 255 ) )) test"
			fi
			umagneto -d iom1 -m <<< $COLOR
			umagneto -d iom0 -m <<< "led on test"
			umagneto -d iom1 -m <<< "led on test"
		fi
		#Check for blink
		if [ "$TYPE" = "blink" ]
            then
            umagneto -d iom0 -m <<< "led $TYPE=$(( ( RANDOM % 17 )  + 1 )) test"
            umagneto -d iom1 -m <<< "led $TYPE=$(( ( RANDOM % 17 )  + 1 )) test"
        fi
        #Check for fade
        if [ "$TYPE" = "fade" ]
            then
            umagneto -d iom0 -m <<< "led $TYPE test"
            umagneto -d iom1 -m <<< "led $TYPE test"
        fi
		for i in {6..53}
		do
		umagneto -d iom0 -m <<< "led state=test $i" &
		umagneto -d iom1 -m <<< "led state=test $i" &
		done
fi
sleep 5
echo ""
echo "Done!"
