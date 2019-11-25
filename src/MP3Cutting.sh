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
# https://unix.stackexchange.com/questions/254072/how-do-i-ask-password-by-gui-prompt-while-using-sudo-in-script
# https://www.shell-tips.com/2010/06/14/performing-math-calculation-in-bash/
# https://unix.stackexchange.com/questions/80532/use-the-terminals-autocomplete-path-feature-for-input-to-a-shell-script
#
# ========================================================================================================================= #

# variables
VERSION="0.6";
numberOfElements="0";

# system variables
GUIMODE=1;
SOX=0;
ZENITY=0;
TXT_FILE="";
MP3_FILE="";
directoryPath="";

# Index, counters
i=0;
ii=0;

clear

# ========================================================================================================================= #

# Helper Functions

function t2s() {
	# returns the time as seconds of the given format HH:MM:SS
	local T=$1;shift
	echo $((10#${T:0:2} * 3600 + 10#${T:3:2} * 60 + 10#${T:6:2}))
}

function timeDiff() {
	diff_time=`expr $2 - $1`
	echo $diff_time
}

function checkArgs() {

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
		# echo "No other command line options are available."
		help
		exit 0
	fi

	if [ $SHELL_ARGS = "--no-gui" ];
	then
		echo -e '\033[1;33mDeactivating graphical user interface ...\033[0m'
		read -p 'Press [ENTER] to continue: ' BREAK

		GUIMODE=0;
	fi

	if [ $SHELL_ARGS = "--debug" ];
	then
		read -p 'Debug mode enabled.' BREAK
		set -x
	fi
}

function help() {

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
	echo '		--help		Prints the command line options.'
	echo '		--version	Output version information and exit.'
	echo '		--no-gui	Start the script in terminal mode (without zenity gui).'
	echo '		--debug		Enables Debug mode. Sox trim is disabled!'
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

function checkEnvironment() {
	echo "Checking environment ..."
	clear

	ZENITY_PATH=`which zenity`
	if [[ $? -eq 0 ]]; then
		ZENITY=1;
		echo -e 'Package zenity found.\t\t\t\t\t\t\t [ \033[1;32m OK \033[0m ]'
	else
		echo -e '\033[1;31mGraphical user mode is not available!\033[0m'
		GUIMODE=0;
		gnome-terminal
		echo -e '\033[1;31mThe package zenity is not installed and neccessary.\033[0m'
		read -p 'Do you want to install it? [y/n]: ' DECISSION

		if [ "$DECISSION" == "y" || "$DECISSION" = "yes" ]; then
			echo -e 'Installing zenity ...'
			sudo apt-get install zenity

			if [[ $? -eq 0 ]]; then
				ZENITY=1;
				clear
			else
				echo -e '\033[1;31mInstallation failed!\033[0m'
				exit -1;
			fi
		else
			echo -e '\033[1;31mInstallation aborted!\033[0m'
			exit -1;
		fi
	fi

	SOX_PATH=`which sox`
	if [[ $? -eq 0 ]]; then
		SOX=1;
		echo -e 'Package sox found.\t\t\t\t\t\t\t [ \033[1;32m OK \033[0m ]'
	else
		if [[ $GUIMODE -eq 0 ]]; then
			echo -e '\033[1;31mThe package sox is not installed and neccessary.\033[0m'
			read -p 'Do you want to install it? [y/n]: ' DECISSION

			if [ "$DECISSION" == "y" || "$DECISSION" == "yes" ]; then
				echo -e 'Installing sox ...'
				sudo apt-get install sox && sudo apt-get install libsox-fmt-mp3

				if [[ $? -eq 0 ]]; then
					SOX=1;
					clear
				else
					echo -e '\033[1;31mInstallation failed!\033[0m'
					exit -1;
				fi
			else
				echo -e '\033[1;31mInstallation aborted!\033[0m'
				exit -1;
			fi
		else
			USERRESPONSE=`zenity --question --title="Package sox not found!" --text="Do you want to install it now?" --width=210 --height=120 > /dev/null 2>&1`
			case $? in
			         0)
			                echo -e 'Installing sox ...'
											pkexec apt-get install sox
											if [[ $? -eq 0 ]]; then
												SOX=1;
												clear
											else
												echo -e '\033[1;31mPermission required!\033[0m'
												exit -1;
											fi;;
			         1)
			                echo -e '\033[1;31mInstallation aborted!\033[0m'
											exit -1;;
			        -1)
			                echo -e '\033[1;31mAn unexpected error has occurred.\033[0m'
											exit -1;;
			esac
		fi
	fi
}

function displayInputParameter() {
	echo "Number of Elements to create: $numberOfElements"
	echo "Input TXT-File: $TXT_FILE"
	echo "Input MP3-File: $MP3_FILE"
	echo "Output Directory: $directoryPath/"
}

function verifyInputParameters() {
	if [[ $GUIMODE -eq 1 && $ZENITY -eq 1 ]]; then
		# nothing to do
		echo "." > /dev/null 2>&1
	else
		# replace whitespace in path
		# TXT_FILE="$(echo $TXT_FILE | sed 's/ /\\ /g')"
		# MP3_FILE="$(echo $MP3_FILE | sed 's/ /\\ /g')"
		# directoryPath="$(echo $directoryPath | sed 's/ /\\ /g')"
		echo "." > /dev/null 2>&1
	fi
}

function loadTimeSteps2Array() {
	echo -e '\nLoading time steps into the array ...'

	while read line
	do
	  # Fixing segmentation fault with pattern -> [0-9][0-9]:[0-9][0-9]:[0-9][0-9] !
	  timeArray[$i]=`echo $line | sed -n 's/.*\([0-9][0-9]:[0-9][0-9]:[0-9][0-9]\).*/\1/p'`
	  echo -e "-> timeArray[$i]: \t${timeArray[$i]}"
	  i=$[$i+1]
	done < "$TXT_FILE"

	echo -e 'Done.\n'
}

function loadMusicTitles2Array() {
	echo -e 'Loading music titles ...'

	while read line
	do
	  # Fixing segmentation fault with deleting numbers in the titles ! -> | sed -e 's/[0-9]//'
	  titleArray[$ii]=`echo $line | sed -e 's/^[0-9]*:*[0-9]*:[0-9]*\s*//'`
	  echo -e "-> titleArray[$ii]: \t${titleArray[$ii]}"
	  ii=$[$ii+1]
	done < "$TXT_FILE"

	echo -e 'Done.\n'
}

function progressBar() {
	setterm -cursor off

	local duration=${1}
	already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇▇▇▇▇▇▇▇"; done }
	remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf "        "; done }
	percentage() { progress=`echo "scale=2;($elapsed/$duration)*100" | bc`; printf "| %s%%" $progress; }
	clean_line() { printf "\r"; }

	for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
			already_done; remaining; percentage
			sleep 1
			clean_line
	done
	clean_line

	setterm -cursor on
}

function initialize() {
	# check for given shell script arguments stored in $1
	checkArgs;

	# check operating system setup for dependencies
	checkEnvironment;
}


function askForTitleTXTFile() {
	if [[ $GUIMODE -eq 1 && $ZENITY -eq 1 ]]; then
		TXT_FILE=`zenity --file-selection --file-filter=*.txt --title="Select the Text File" 2>/dev/null`

		case $? in
		         0)
	                echo -e 'Loading TXT File ... \t\t\t\t\t\t\t [ \033[1;32m OK \033[0m ]'
									echo "=> $TXT_FILE";;
		         1)
	                echo -e 'Loading TXT File ... \t\t\t\t\t\t\t [ \033[1;31mFAIL\033[0m ]'
									echo -e '\033[1;31mCan not find the selected file !\033[0m'
									exit -1;;
		        -1)
	                echo -e '\033[1;31mAn unexpected error has occurred.\033[0m'
									exit -1;;
		esac
	else
		read -p "Please specify the path to the title file (*.txt): " -i "$HOME/" -e TXT_FILE
		CHECKINPUT=`echo $TXT_FILE | grep .txt`

		if [[ $? -ne 0 ]]; then
			echo -e "\033[1;31m$TXT_FILE does not match type *.txt !\033[0m"
			exit -1;
		else
			if [[ ! -f "$TXT_FILE" ]]; then
				echo -e "\033[1;31mCan not find the selected file !\033[0m"
				exit -1;
			fi
		fi
	fi
}

function askForMP3AudioFile() {
	if [[ $GUIMODE -eq 1 && $ZENITY -eq 1 ]]; then
		MP3_FILE=`zenity --file-selection --file-filter=*.mp3 --title="Select the MP3 File" 2>/dev/null`

		case $? in
		         0)
		                echo -e 'Loading MP3 File ... \t\t\t\t\t\t\t [ \033[1;32m OK \033[0m ]'
										echo "=> $MP3_FILE";;
		         1)
		                echo -e 'Loading MP3 File ... \t\t\t\t\t\t\t [ \033[1;31mFAIL\033[0m ]'
										echo -e '\033[1;31mCan not find the selected file !\033[0m'
										exit -1;;
		        -1)
		                echo -e '\033[1;31mAn unexpected error has occurred.\033[0m'
										exit -1;;
		esac
	else
		TXTDIRECTORY="${TXT_FILE%/*}"
		STARTDIR="$(echo $TXTDIRECTORY | sed 's/ /\\ /g')"

		read -p "Please specify the path to the mp3 audio file: " -i "$STARTDIR/" -e MP3_FILE
		CHECKINPUT=`echo $MP3_FILE | grep .mp3`

		if [[ $? -ne 0 ]]; then
			echo -e "\033[1;31m$MP3_FILE does not match type *.mp3 !\033[0m"
			exit -1;
		else
			if [[ ! -f "$MP3_FILE" ]]; then
				echo -e "\033[1;31mCan not find the selected file !\033[0m"
				exit -1;
			fi
		fi
	fi
}

function askForOutputDirectory() {
	if [[ $GUIMODE -eq 1 && $ZENITY -eq 1 ]]; then
		directoryPath=`zenity --file-selection --directory --save --title="Select a directory for saving" 2>/dev/null`

		case $? in
		         0)
						 				echo -e 'Opening directory ... \t\t\t\t\t\t\t [ \033[1;32m OK \033[0m ]'
							      echo "=> Saving Directory: $directoryPath selected.";;
		         1)
		                echo -e '\033[1;31mNo Directory selected.\033[0m'
										exit -1;;
		        -1)
		                echo -e '\033[1;31mAn unexpected error has occurred.\033[0m'
										exit -1;;
		esac
	else
		read -p "Please specify the path to store the project: " -i "$STARTDIR/" -e directoryPath

		if [[ ! -d "$directoryPath" ]]; then
			echo -e "\033[1;31mCan not find directory $directoryPath !\033[0m"
			exit -1;
		fi
	fi
}


function initCuttingAudioFile() {
	# prepare input parameters
	verifyInputParameters;

	# loading all time steps in time array
	loadTimeSteps2Array;

	# loading all titles in title array
	loadMusicTitles2Array;
}

function cuttingMP3AudioFile() {
	numberOfElements=$ii

	if [ $numberOfElements != $i ]
	then
		echo -e '\033[1;31mError: Number of TimeElements does not fit with the title numbers!\033[0m'
		exit -1;
	else
		displayInputParameter;

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

			if [[ $GUIMODE -eq 1 && $ZENITY -eq 1 ]]; then
				echo "scale=2;($titleNumber/$numberOfElements)*100" | bc
				echo "# [$titleNumber/$numberOfElements]: $fileName"
			else
				# TODO: text mode progressBar
				# progressBar 10
			fi
		done
	fi

	echo
	if [[ $GUIMODE -eq 1 && $ZENITY -eq 1 ]]; then
		echo "# Finished $numberOfElements jobs !"
	else
		echo "Finished $numberOfElements jobs !"
	fi
	echo "Done."
}

# ========================================================================================================================= #

# initialize system
initialize;

# file selection -> txt
askForTitleTXTFile;

# file selection -> MP3
askForMP3AudioFile;

# directory to save the files to
askForOutputDirectory;

# initialize variables and arrays
initCuttingAudioFile;

# cutting / trimming the mp3 file
if [[ $GUIMODE -eq 1 && $ZENITY -eq 1 ]]; then
	cuttingMP3AudioFile | zenity --progress \
	--title="Preparing mp3 audio tracks" \
	--text="Loading tracks ..." \
	--percentage=0 \
	--width=300 --height=140 2>/dev/null

	if [[ $? -eq -1 ]]; then
  	zenity --error --text="Update canceled." 2>/dev/null
		exit -1;
	fi
else
	cuttingMP3AudioFile;
fi

# ========================================================================================================================= #
# ========================================================================================================================= #
