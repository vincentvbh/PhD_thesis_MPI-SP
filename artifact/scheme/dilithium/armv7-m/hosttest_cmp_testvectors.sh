#!/bin/bash

diff <(./obj_armv7/dilithium2_ref_testvectors) <(./obj_armv7/dilithium2_old_testvectors)
diff <(./obj_armv7/dilithium2_ref_testvectors) <(./obj_armv7/dilithium2_opt_testvectors)

diff <(./obj_armv7/dilithium3_ref_testvectors) <(./obj_armv7/dilithium3_old_testvectors)
diff <(./obj_armv7/dilithium3_ref_testvectors) <(./obj_armv7/dilithium3_opt_testvectors)

diff <(./obj_armv7/dilithium5_old_testvectors) <(./obj_armv7/dilithium5_opt_testvectors)

