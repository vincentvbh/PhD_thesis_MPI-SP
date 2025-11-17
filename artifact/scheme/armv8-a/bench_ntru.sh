#!bin/bash

outfile=ntru/speed_data_$1.txt

rm -f $outfile

run_collect(){
echo "======== $1 ========" >> $outfile
if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo ./$1 >> $outfile
else
    ./$1 >> $outfile
fi
}

run_collect ntru/obj/ntruhps2048677_old_speed
run_collect ntru/obj/ntruhps2048677_opt_tc_speed
run_collect ntru/obj/ntruhps2048677_opt_tmvp_speed
run_collect ntru/obj/ntruhps2048677_opt_speed

run_collect ntru/obj/ntruhrss701_old_speed
run_collect ntru/obj/ntruhrss701_opt_tmvp_speed
run_collect ntru/obj/ntruhrss701_opt_speed

