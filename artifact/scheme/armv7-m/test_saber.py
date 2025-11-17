#!/usr/bin/env python3

import datetime
import subprocess
import sys
from os.path import exists

import serial
import numpy as np
from config import Settings

testType = "test"
schemeName = "saber"
iterations = 10
paramSetList = ["lightsaber", "saber", "firesaber"]
impleList = ["ref", "old_tc", "old_32bit", "old_16bit", "opt"]
cpu = ""

runned = []
skipped = []

def getBinary(scheme, paramSet, impl):
    return f"{scheme}/elf/{paramSet}_{impl}_{testType}.elf"

def getFlash(binary):
    return f"openocd -f nucleo-f2.cfg -c \"program {binary} reset exit\" "

def makeAll():
    if Settings.CLEAN == True:
        subprocess.check_call(f"make clean", shell=True)
    subprocess.check_call(f"make {schemeName} -j {Settings.JOBS} ITERATIONS={iterations} DEVICE={Settings.DEVICE}", shell=True)

def test(scheme, paramSet, impl):
    binary = getBinary(scheme, paramSet, impl)

    if exists(binary) == 0:
        skipped.append(binary)
        print(f"skip {binary}")
        return b""

    try:
        subprocess.check_call(getFlash(binary), shell=True)
    except:
        print(f"openocd failed --> retry {binary}")
        return test(scheme, paramSet, impl)

    runned.append(binary)

    with serial.Serial(Settings.SERIAL_DEVICE, Settings.BAUD_RATE, timeout=10) as dev:
        log = b""

        while True:
            device_output = dev.read()
            if device_output == b'':
                print(f"timeout --> retry {binary}")
                return test(scheme, paramSet, impl)
            sys.stdout.buffer.write(device_output)
            sys.stdout.flush()
            log += device_output
            if device_output == b'#':
                break

    log = log.decode(errors="ignore")
    assert log.count(f"ERROR") == 0

makeAll()

for paramSet in paramSetList:
    for imple in impleList:
        test(schemeName, paramSet, cpu + imple)

print("\n======== Runned ========\n")
print(str.join('\n', runned))
print("\n======== Skipped ========\n")
print(str.join('\n', skipped))


