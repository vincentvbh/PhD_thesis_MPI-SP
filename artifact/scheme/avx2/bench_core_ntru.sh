#!bin/bash

outfile=ntru/speed_local_data_$1.txt

rm -f $outfile

run_collect(){
echo "======== $1 ========" >> $outfile
if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo ./$1 >> $outfile
else
    ./$1 >> $outfile
fi
}

run_collect ntru/obj/ntruhps2048677_old_tc_speed_local

run_collect ntru/obj/ntruhrss701_old_tc_speed_local

