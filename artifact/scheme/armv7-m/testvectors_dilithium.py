#!/usr/bin/env python3

import datetime
import subprocess
import sys
import filecmp
from os.path import exists

import serial
import numpy as np
from config import Settings

testType = "testvectors"
schemeName = "dilithium"
iterations = 1
paramSetList = ["dilithium2", "dilithium3", "dilithium5"]
impleList = [ "ref", "old", "opt"]
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

    print(f"found {binary}")

    outfile = open(f"{scheme}/testvectors_{paramSet}_{imple}.txt", "w+")

    try:
        subprocess.check_call(getFlash(binary), shell=True)
    except:
        print(f"st-flash failed --> retry {binary}")
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
    log = log.replace('=', '')
    log = log.splitlines()
    log = [line for line in log if line.strip()]
    log = '\n'.join(log)
    outfile.write(log)
    outfile.flush()
    outfile.close()

makeAll()

for paramSet in paramSetList:
    for imple in impleList:
        test(schemeName, paramSet, cpu + imple)

print("\n======== Run ========\n")
print(str.join('\n', runned))
print("\n======== Skipped ========\n")
print(str.join('\n', skipped))

for paramSet in paramSetList:
    ref = None
    for imple in impleList:
        if exists(f"{schemeName}/testvectors_{paramSet}_{imple}.txt"):
            if ref == None:
                ref = f"{schemeName}/testvectors_{paramSet}_{imple}.txt"
            else:
                assert filecmp.cmp(ref, f"{schemeName}/testvectors_{paramSet}_{imple}.txt") == True

print("\n======== Testvectors compared ========\n")

