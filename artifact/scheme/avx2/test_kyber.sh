#!bin/bash

./kyber/obj/kyber512_ref_test | grep "ERROR"
./kyber/obj/kyber768_ref_test | grep "ERROR"
./kyber/obj/kyber1024_ref_test | grep "ERROR"
./kyber/obj/kyber512_old_test | grep "ERROR"
./kyber/obj/kyber768_old_test | grep "ERROR"
./kyber/obj/kyber1024_old_test | grep "ERROR"
./kyber/obj/kyber512_opt_test | grep "ERROR"
./kyber/obj/kyber768_opt_test | grep "ERROR"
./kyber/obj/kyber1024_opt_test | grep "ERROR"

