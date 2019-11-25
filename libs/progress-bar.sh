#!/bin/bash

# https://stackoverflow.com/questions/2388090/how-to-delete-and-replace-last-line-in-the-terminal-using-bash#6774395

function progressBar() {
	setterm -cursor off

  local size=10;
	local duration=${1};

	already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
	remaining() { for ((remain=$elapsed; remain<$size; remain++)); do printf " "; done }
	percentage() { progress=`echo "scale=2;($elapsed/$size)*100" | bc`; printf "| %s%%" $progress; }
	clean_line() { printf "\r"; }

	for (( elapsed=1*($size/$duration); elapsed<=$size; elapsed+=($size/$duration) )); do
			already_done; remaining; percentage
			sleep 1
			clean_line
	done
	clean_line

	setterm -cursor on
  echo -e "\n"
}

function progressBar2() {
  pass='number1 number2 number 3 number4 number12 number13 number14 number15 number16'
  chk='number15'
  result="Not Found!"

  echo
  echo -n "Working... "
  echo -ne "\033[1;32m\033[7m\033[?25l"

  for i in $pass ; do
     sleep .4s
     if [ "$i" == "$chk" ]; then
        result="  Found ^_^"
        break
     else
        echo -n " "
     fi
  done

  echo -ne "\r\033[0m\033[K\033[?25h"
  echo $result
  echo
}

function progressbar3() {
	local percentage=${1};
	message=${2};

	tput rc
	tput ed

  printf "$message";

	for ((j=1; j<100; j++)); do
		printf " ";
	done;

	printf "\n"

	tput sc;
  printf "%0.s▇" $(seq 1 $percentage);
  printf "%0.s " $(seq $percentage 100);
  printf "| %3d%%\r" "$percentage";

	sleep 0.1
}

#######################################

clear

counter=0;
setterm -cursor off

while [[ $counter -lt 101 ]]; do
	progressbar3 $counter
	counter=$((counter+1))

	if [[ $counter -eq 25 ]]; then
			progressbar3 $counter "$counter percent reached."
	fi

	if [[ $counter -eq 50 ]]; then
			progressbar3 $counter "$counter percent reached."
	fi

	if [[ $counter -eq 75 ]]; then
			progressbar3 $counter "$counter percent reached."
	fi
done

setterm -cursor on
echo -e "\n"
