#!bin/bash

outfile=dilithium/speed_local_data_$1.txt

rm -f $outfile

run_collect(){
echo "======== $1 ========" >> $outfile
if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo ./$1 >> $outfile
else
    ./$1 >> $outfile
fi
}

run_collect dilithium/obj/dilithium2_old_speed_local

run_collect dilithium/obj/dilithium3_old_speed_local

run_collect dilithium/obj/dilithium5_old_speed_local

