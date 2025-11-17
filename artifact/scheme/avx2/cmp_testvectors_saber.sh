#! bin/bash

diff <(./saber/obj/lightsaber_ref_testvectors) <(./saber/obj/lightsaber_old_tc_testvectors)
diff <(./saber/obj/lightsaber_ref_testvectors) <(./saber/obj/lightsaber_old_ntt_testvectors)

diff <(./saber/obj/saber_ref_testvectors) <(./saber/obj/saber_old_tc_testvectors)
diff <(./saber/obj/saber_ref_testvectors) <(./saber/obj/saber_old_ntt_testvectors)

diff <(./saber/obj/firesaber_ref_testvectors) <(./saber/obj/firesaber_old_tc_testvectors)
diff <(./saber/obj/firesaber_ref_testvectors) <(./saber/obj/firesaber_old_ntt_testvectors)

