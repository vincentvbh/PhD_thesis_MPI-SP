#! bin/bash

diff <(./ntru/obj/ntruhps2048677_ref_testvectors) <(./ntru/obj/ntruhps2048677_old_testvectors)
diff <(./ntru/obj/ntruhps2048677_ref_testvectors) <(./ntru/obj/ntruhps2048677_opt_tc_testvectors)
diff <(./ntru/obj/ntruhps2048677_ref_testvectors) <(./ntru/obj/ntruhps2048677_opt_tmvp_testvectors)
diff <(./ntru/obj/ntruhps2048677_ref_testvectors) <(./ntru/obj/ntruhps2048677_opt_testvectors)

diff <(./ntru/obj/ntruhrss701_ref_testvectors) <(./ntru/obj/ntruhrss701_old_testvectors)
diff <(./ntru/obj/ntruhrss701_ref_testvectors) <(./ntru/obj/ntruhrss701_opt_tmvp_testvectors)
diff <(./ntru/obj/ntruhrss701_ref_testvectors) <(./ntru/obj/ntruhrss701_opt_testvectors)

