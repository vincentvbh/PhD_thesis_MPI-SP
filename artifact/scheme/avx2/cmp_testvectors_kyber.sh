#! bin/bash

diff <(./kyber/obj/kyber512_ref_testvectors) <(./kyber/obj/kyber512_old_testvectors)
diff <(./kyber/obj/kyber512_ref_testvectors) <(./kyber/obj/kyber512_opt_testvectors)

diff <(./kyber/obj/kyber768_ref_testvectors) <(./kyber/obj/kyber768_old_testvectors)
diff <(./kyber/obj/kyber768_ref_testvectors) <(./kyber/obj/kyber768_opt_testvectors)

diff <(./kyber/obj/kyber1024_ref_testvectors) <(./kyber/obj/kyber1024_old_testvectors)
diff <(./kyber/obj/kyber1024_ref_testvectors) <(./kyber/obj/kyber1024_opt_testvectors)

