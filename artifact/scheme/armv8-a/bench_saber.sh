#!bin/bash

outfile=saber/speed_data_$1.txt

rm -f $outfile

run_collect(){
echo "======== $1 ========" >> $outfile
if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo ./$1 >> $outfile
else
    ./$1 >> $outfile
fi
}

run_collect saber/obj/lightsaber_old_tc_speed
run_collect saber/obj/lightsaber_old_speed

run_collect saber/obj/saber_old_tc_speed
run_collect saber/obj/saber_old_speed

run_collect saber/obj/firesaber_old_tc_speed
run_collect saber/obj/firesaber_old_speed

