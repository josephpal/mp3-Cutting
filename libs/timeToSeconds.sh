#!/bin/bash

function t2s(){
	local T=$1;shift
	echo $((10#${T:0:2} * 3600 + 10#${T:3:2} * 60 + 10#${T:6:2}))
}

start_time=00:00:00
end_time=00:05:26

diff_time=$(($(t2s $end_time) - $(t2s $start_time) ))
echo -e "Start Time: \t\t$start_time"
echo -e "End Time: \t\t$end_time"
echo -e "Time Difference:\t$diff_time"


