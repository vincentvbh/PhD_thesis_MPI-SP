
import argparse
import multiprocessing
import platform

class Settings:

    parser = argparse.ArgumentParser()

    parser.add_argument('--jobs', default = multiprocessing.cpu_count())
    parser.add_argument('--device', default = "stm32f4discovery")

    if platform.system() == "Darwin":
        parser.add_argument('--serial_device', default = "/dev/tty.usbserial-0001")
    else:
        parser.add_argument('--serial_device', default = "/dev/ttyACM0")

    parser.add_argument('--baud_rate', default = 38400)
    parser.add_argument('--clean', default=False, action = 'store_true')

    args = parser.parse_args()

    JOBS = args.jobs
    DEVICE = args.device
    SERIAL_DEVICE = args.serial_device
    BAUD_RATE = args.baud_rate
    CLEAN = args.clean
