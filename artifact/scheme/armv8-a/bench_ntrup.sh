#!bin/bash

outfile=ntrup/speed_data_$1.txt

rm -f $outfile

run_collect(){
echo "======== $1 ========" >> $outfile
if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo ./$1 >> $outfile
else
    ./$1 >> $outfile
fi
}

run_collect ntrup/obj/sntrup761_opt_gt_speed
run_collect ntrup/obj/sntrup761_opt_schoenhage_speed
run_collect ntrup/obj/sntrup761_opt_rader_speed
run_collect ntrup/obj/sntrup761_opt_truncated_rader_speed
run_collect ntrup/obj/sntrup761_opt_speed

