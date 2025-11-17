#!/bin/bash

diff <(./obj_armv7/lightsaber_ref_testvectors) <(./obj_armv7/lightsaber_old_testvectors)
diff <(./obj_armv7/lightsaber_ref_testvectors) <(./obj_armv7/lightsaber_opt_testvectors)

diff <(./obj_armv7/saber_ref_testvectors) <(./obj_armv7/saber_old_testvectors)
diff <(./obj_armv7/saber_ref_testvectors) <(./obj_armv7/saber_opt_testvectors)

diff <(./obj_armv7/firesaber_ref_testvectors) <(./obj_armv7/firesaber_old_testvectors)
diff <(./obj_armv7/firesaber_ref_testvectors) <(./obj_armv7/firesaber_opt_testvectors)

