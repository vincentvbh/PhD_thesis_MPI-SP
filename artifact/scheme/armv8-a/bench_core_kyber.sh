#!bin/bash

outfile=kyber/speed_local_data_$1.txt

rm -f $outfile

run_collect(){
echo "======== $1 ========" >> $outfile
if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo ./$1 >> $outfile
else
    ./$1 >> $outfile
fi
}

run_collect kyber/obj/kyber512_old_speed_local
run_collect kyber/obj/kyber512_opt_speed_local

run_collect kyber/obj/kyber768_old_speed_local
run_collect kyber/obj/kyber768_opt_speed_local

run_collect kyber/obj/kyber1024_old_speed_local
run_collect kyber/obj/kyber1024_opt_speed_local

