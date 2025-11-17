#! bin/bash

diff <(./ntru/obj/ntruhps2048677_ref_testvectors) <(./ntru/obj/ntruhps2048677_old_tc_testvectors)
diff <(./ntru/obj/ntruhps2048677_ref_testvectors) <(./ntru/obj/ntruhps2048677_old_ntt_testvectors)

diff <(./ntru/obj/ntruhrss701_ref_testvectors) <(./ntru/obj/ntruhrss701_old_tc_testvectors)
diff <(./ntru/obj/ntruhrss701_ref_testvectors) <(./ntru/obj/ntruhrss701_old_ntt_testvectors)

