#!bin/bash

./dilithium/obj/dilithium2_ref_test | grep "ERROR"
./dilithium/obj/dilithium3_ref_test | grep "ERROR"
./dilithium/obj/dilithium5_ref_test | grep "ERROR"
./dilithium/obj/dilithium2_old_test | grep "ERROR"
./dilithium/obj/dilithium3_old_test | grep "ERROR"
./dilithium/obj/dilithium5_old_test | grep "ERROR"
./dilithium/obj/dilithium2_opt_test | grep "ERROR"
./dilithium/obj/dilithium3_opt_test | grep "ERROR"
./dilithium/obj/dilithium5_opt_test | grep "ERROR"

