#! bin/bash

diff <(./ntrup/obj/sntrup761_ref_testvectors) <(./ntrup/obj/sntrup761_opt_gt_testvectors)
diff <(./ntrup/obj/sntrup761_ref_testvectors) <(./ntrup/obj/sntrup761_opt_schoenhage_testvectors)
diff <(./ntrup/obj/sntrup761_ref_testvectors) <(./ntrup/obj/sntrup761_opt_rader_testvectors)
diff <(./ntrup/obj/sntrup761_ref_testvectors) <(./ntrup/obj/sntrup761_opt_truncated_rader_testvectors)
diff <(./ntrup/obj/sntrup761_ref_testvectors) <(./ntrup/obj/sntrup761_opt_testvectors)

