#!/bin/sh

root_path="/tmp"
mkdir -p $root_path/SystemChkOutFiles
STAMP=`date +%Y%m%d_%H%M%S`
out_file="${root_path}/OutFiles/memusage_${STAMP}.out"

date > $out_file
hostname >> $out_file
free >> $out_file
echo -e "\n\n================================================\n\n" >> $out_file
echo "CPU%      Mem%    TMem    Process" >> $out_file
ps aux | awk '{mem[$11]+=int($6/1024)}; {cpuper[$11]+=$3};{memper[$11]+=$4}; END {for (i in mem) {print cpuper[i]"% ",memper[i]"% ",mem[i]" MB ",i}}' | sort -k3nr | grep -v "0 MB" >> $out_file
echo -e "\n================================================\n\n" >> $out_file

top -b -n 1  >> $out_file


minute=`date +%M`
echo $minute
expr $minute+0
if (( $minute%5==0 )); then
        echo "5 minute interval"
fi


find $root_path/SystemChkOutFiles/memusage* -mmin +720 -exec rm -f {} \;   2>/dev/null
