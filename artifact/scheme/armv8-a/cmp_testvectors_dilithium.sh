#! bin/bash

diff <(./dilithium/obj/dilithium2_ref_testvectors) <(./dilithium/obj/dilithium2_old_testvectors)
diff <(./dilithium/obj/dilithium2_ref_testvectors) <(./dilithium/obj/dilithium2_opt_testvectors)

diff <(./dilithium/obj/dilithium3_ref_testvectors) <(./dilithium/obj/dilithium3_old_testvectors)
diff <(./dilithium/obj/dilithium3_ref_testvectors) <(./dilithium/obj/dilithium3_opt_testvectors)

diff <(./dilithium/obj/dilithium5_ref_testvectors) <(./dilithium/obj/dilithium5_old_testvectors)
diff <(./dilithium/obj/dilithium5_ref_testvectors) <(./dilithium/obj/dilithium5_opt_testvectors)

