#!/usr/bin/env python3

import datetime
import subprocess
import sys
from os.path import exists

import serial
import numpy as np
from config import Settings

testType = "test"
iterations = 10
schemeList = ["kyber512", "kyber768", "kyber1024"]
impleList = ["ref", "old", "opt"]
cpu = ""

runned = []
skipped = []

def getBinary(scheme, impl):
    return f"bin/{scheme}_{impl}_{testType}.bin"

def getFlash(binary):
    return f"st-flash --reset write {binary} 0x8000000"

def makeAll():
    if Settings.CLEAN == True:
        subprocess.check_call(f"make clean", shell=True)
    subprocess.check_call(f"make all -j {Settings.JOBS} ITERATIONS={iterations} DEVICE={Settings.DEVICE}", shell=True)

def test(scheme, impl):
    binary = getBinary(scheme, impl)

    if exists(binary) == 0:
        skipped.append(binary)
        print(f"skip {binary}")
        return b""

    try:
        subprocess.check_call(getFlash(binary), shell=True)
    except:
        print(f"st-flash failed --> retry {binary}")
        return test(scheme, impl)

    runned.append(binary)

    with serial.Serial(Settings.SERIAL_DEVICE, Settings.BAUD_RATE, timeout=10) as dev:
        log = b""

        while True:
            device_output = dev.read()
            if device_output == b'':
                print(f"timeout --> retry {binary}")
                return test(scheme, impl)
            sys.stdout.buffer.write(device_output)
            sys.stdout.flush()
            log += device_output
            if device_output == b'#':
                break

    log = log.decode(errors="ignore")
    assert log.count(f"ERROR: {binary}") == 0

makeAll()

for scheme in schemeList:
    for imple in impleList:
        test(scheme, cpu + imple)

print("\n======== Runned ========\n")
print(str.join('\n', runned))
print("\n======== Skipped ========\n")
print(str.join('\n', skipped))


