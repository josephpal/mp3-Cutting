#!/bin/bash

SHELL_ARGS=$1

# ========================================================================================================================= #
#
# Be careful that the package zenity is installed. You can install it via
# terminal with 'sudo apt-get install zenity'. Otherwise the script will install it.
#
# ========================================================================================================================= #
#
# MP3Cutting.sh.sh - A sample shell script which can split an MP3 file based on a txt file into seperated songs
#
# ========================================================================================================================= #
#
# Date: 27.10.2015
# Contributor: Joseph Pal
# IDE: gedit
# License: GNU General Public License (GPL), Open Source License (OSI/OSD)
# Support: xri-chat, nickname: joseph, channel: #linuxmint-help
# Email: jose199441@gmail.com
# Operating System: Linux® Mint 17
# Tested with: Linux® Mint, Ubuntu 14.04 LTS
#
# ========================================================================================================================= #
#　
# The GNU License Logo
#
#　　　　　　　　　　　　　　 
#	　 /}　　　 　 　 {ヽ　　　 
#	 〈 廴,　 　 　 　 〉〉_.. 
#	　 ＼/^Y⌒,二彡' .: ,.-‐=
#	　　,ﾉ.:.:::ヽ/.: . .:
#	　 〈|:..:.:.::ぅ.:ﾐ＜
#	　　j..:..:.:..:..:. .
#	　　|..:.:.:.::.ﾄﾐ..:..
#	　　ｌ.:::.::...:ﾄﾐ.:.::
#	　　j.:.:.::::::ゞﾐ爪州ﾘ
#	　　ﾞVっ:.:..:.:ﾘ川jfﾄﾊﾘ
#	　 　 `ー''"彡ﾘﾊｊ　　　　　　 　 
#
#　
# http://lh4.ggpht.com/_ctbzgC-JfcA/TTA7GelmCeI/AAAAAAAACYU/oHk1rsKPH40/w700/gnu_1.gif 　 
#　 　
# ========================================================================================================================= #
#
# Terms of Agreement of this product:
#
# Date: 27.10.2015
# Developer: Joseph Pal
# License: GNU General Public License (GPL), Open Source License (OSI/OSD)
# Version: 0.6
#
# OFFICIAL LICENSE AGREEMENT OF THIS SOFTWARE
#
# The developer of this Sofware will not be liable for errors or damages
# on your Linux distribution caused by this software.
# Therefore the user of this product can not demand an account.
# Also it is not able to charge any compensation.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#  
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
# ========================================================================================================================= #
#	
# For more help and information visit the following internet pages:
#
# http://de.wikipedia.org/wiki/GNU_General_Public_License
# http://en.wikipedia.org/wiki/Open-source_license
# http://www.christian-hoenick.com/blog/2012/01/06/shell-string-abschneiden-oder-entfernen-teilstring/
# http://unix.stackexchange.com/questions/97314/need-to-get-the-difference-between-two-time-in-seconds
# http://www.tutorialspoint.com/unix/unix-using-arrays.htm
# http://superuser.com/questions/112834/how-to-match-whitespace-in-sed
# https://help.gnome.org/users/zenity/stable/file-selection.html.en
# http://linux.byexamples.com/archives/259/a-complete-zenity-dialog-examples-1/
# http://manpages.ubuntu.com/manpages/natty/man1/zenity.1.html
#
# ========================================================================================================================= #

# Variables

VERSION="0.6"
numberOfElements="0"
i=0;
ii=0;

clear

# ========================================================================================================================= #
# ========================================================================================================================= #

# Helper Functions

function t2s(){
	# returns the time as seconds of the given format HH:MM:SS	
	local T=$1;shift
	echo $((10#${T:0:2} * 3600 + 10#${T:3:2} * 60 + 10#${T:6:2}))
}

function timeDiff(){
	diff_time=`expr $2 - $1` 	
	echo $diff_time
}

function check_Args(){
	
	if [ -z "$SHELL_ARGS" ];
	then
		echo 'SHELL_ARGS=null'
		SHELL_ARGS='null'
	fi
	
	
	if [ $SHELL_ARGS = "--version" ];
	then
		echo "Version: $VERSION"
		exit 0
	fi
		
	if [ $SHELL_ARGS = "--help" ];
	then
		# echo "No other command line options are aviable."
		help
		exit 0
	fi
	
	if [ $SHELL_ARGS = "--debug" ];
	then
		read -p 'Debug mode enabled.' BREAK 
		set -x
	fi
}

function help(){
	
	clear
	echo 'Opening help page ...'
	sleep 1
	clear

	echo -e '\033[1;32mMP3Cutting.sh(1)	      General Commands Manual           MP3Cutting.sh(1)\033[0m'
	echo 
	echo 'NAME'
	echo '		MP3Cutting.sh - Cut MP3 files into single titles'
	echo
	echo 'SYNOPSIS'
	echo '		MP3Cutting.sh [OPTION]...'
	echo
	echo 'DESCRIPTION'
	echo '		A sample shell script which can split an MP3 file based on a '
	echo '		txt file into seperated songs'
	echo
	echo 'OPTIONS'
	echo '		--help		Prints the command line options'
	echo '		--version	Output version information and exit'
	echo '		--start		Start the main routine of the script'
	echo '		--debug		Enables Debug mode. Sox trim is disabled !'
	echo 'BUGS'
	echo '		If you find a bug, please report it to jose199441@gmail.com'
	echo
	echo 'AUTHORS'  
	echo '		Joseph Pal'
	echo

    	OUTPUT=`echo -e "\033[1;32mMP3Cutting.sh(1) 	           27 Okt 2015                  MP3Cutting.sh(1)\033[0m"`
    	read -p "$OUTPUT" BREAK
	clear
	exit 0
}

# ========================================================================================================================= #
check_Args
# ========================================================================================================================= #

# File Selection -> txt

TXT_FILE=`zenity --file-selection --file-filter=*.txt --title="Select the Text File"`

case $? in
         0)
                echo -e 'Loading TXT File ... \t\t\t\t\t\t\t [ \033[1;32mOK \033[0m ]\n';;
         1)
                echo -e 'Loading TXT File ... \t\t\t\t\t\t\t[ \033[1;31mFAIL\033[0m ]'
		echo -e '\033[1;31mCan not find the selected file !\033[0m'
		exit -1;;
        -1)
                echo -e '\033[1;31mAn unexpected error has occurred.\033[0m'
		exit -1;;
esac

# File Selection -> MP3

MP3_FILE=`zenity --file-selection --file-filter=*.mp3 --title="Select the MP3 File"`

case $? in
         0)
                echo -e 'Loading MP3 File ... \t\t\t\t\t\t\t [ \033[1;32mOK \033[0m ]\n';;
         1)
                echo -e 'Loading MP3 File ... \t\t\t\t\t\t\t[ \033[1;31mFAIL\033[0m ]'
		echo -e '\033[1;31mCan not find the selected file !\033[0m'
		exit -1;;
        -1)
                echo -e '\033[1;31mAn unexpected error has occurred.\033[0m'
		exit -1;;
esac

# Directory to save the files to

directoryPath=`zenity --file-selection --directory --save --title="Select a directory for saving"`

case $? in
         0)
                echo "Saving Directory: $directoryPath selected.";;
         1)
                echo -e '\033[1;31mNo Directory selected.\033[0m'
		exit -1;;
        -1)
                echo -e '\033[1;31mAn unexpected error has occurred.\033[0m'
		exit -1;;
esac
	
# ========================================================================================================================= #
# ========================================================================================================================= #

# Loading all time steps in timeArray

echo -e 'Loading Time Steps into the Array ...'

while read line
do 
  
  # tmp=`echo $line | sed s/[^0-9:0-9]//g`
  # echo $tmp
  
  # Fixing segmentation fault with pattern -> [0-9][0-9]:[0-9][0-9]:[0-9][0-9] !
  timeArray[$i]=`echo $line | sed -n 's/.*\([0-9][0-9]:[0-9][0-9]:[0-9][0-9]\).*/\1/p'`
  echo "Time[$i]: ${timeArray[$i]}"
  i=$[$i+1]

done < "$TXT_FILE"

echo -e 'Done.\n'

# ========================================================================================================================= #
# ========================================================================================================================= #

# Loading all Titles in title Array

echo -e 'Loading Music Titles ...'

while read line
do 
  
  # Fixing segmentation fault with deleting numbers in the titles ! -> | sed -e 's/[0-9]//'
  titleArray[$ii]=`echo $line | sed -e 's/^[0-9]*:*[0-9]*:[0-9]*\s*//'`
  echo "Title[$ii]: ${titleArray[$ii]}"
  ii=$[$ii+1]

done < "$TXT_FILE"

echo -e 'Done.\n'

# ========================================================================================================================= #
# ========================================================================================================================= #

# Cutting / Trimming the mp3 file

numberOfElements=$ii

if [ $numberOfElements != $i ]
then
	echo -e '\033[1;31mError: Number of TimeElements doesnt fit with the Titlenumbers\033[0m'
	exit -1
else
	echo "Number of Elements to create: $numberOfElements"
	echo "Input TXT-File: $TXT_FILE"
	echo "Input MP3-File: $MP3_FILE"
	echo "Output Directory: $directoryPath/"

	endOfFile=`expr $numberOfElements - 1`
	echo -e "EOF: After $endOfFile Tracks\n"
	
	for (( element=0; element <= $numberOfElements-1; ++element ))
	do
		# Add the title Number to the filename
		if [ $element -le "8" ];
		then
			titleNumber="0"`expr $element + 1`
		else
			titleNumber=`expr $element + 1`
		fi

		# Generates the filename
		fileName=$titleNumber" - "${titleArray[$element]}".mp3"

		if [ $element -lt $endOfFile ];
		then			
			# Calculate th lenght of one title			
			titleDuration=$(($(t2s ${timeArray[$element+1]}) - $(t2s ${timeArray[$element]}) ))
	
			echo -e "[$element]:\t${timeArray[$element]} to ${timeArray[$element+1]} Length: $titleDuration Seconds -> $fileName"
			
			if [ $SHELL_ARGS = "--debug" ];
			then		
				# Nothing to do -> Debug mode disable sox trimming !
				echo -e "\n"
			else
				# sox Inputfile Outputfile trim Start Duration(t) -> NOT Endtime !!!
				sox "$MP3_FILE" "$directoryPath/$fileName" trim ${timeArray[$element]} $titleDuration > /dev/null 2>&1
			fi
		else
			if [ $SHELL_ARGS = "--debug" ];
			then
				# Nothing to do -> Debug mode disable sox trimming !
				echo -e "\n"
			else	
				echo -e "[$element]:\t${timeArray[$element]} to EOF -> $fileName"
				sox "$MP3_FILE" "$directoryPath/$fileName" trim "${timeArray[$element]}" > /dev/null 2>&1
			fi
		fi  		
	done
fi

echo .
echo "Finished $numberOfElements jobs !"
echo "Done."

# ========================================================================================================================= #
