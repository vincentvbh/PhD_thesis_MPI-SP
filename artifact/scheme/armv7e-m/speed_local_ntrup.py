#!/usr/bin/env python3

import datetime
import subprocess
import sys
from os.path import exists

import serial
import numpy as np
from config import Settings

testType = "speed_local"
schemeName = "ntrup"
outFileName = f"{schemeName}/speed_local.txt"
paramSetList = ["sntrup761"]
impleList = ["old_1536", "old_1530"]
cpu = ""

runned = []
skipped = []

def getBinary(scheme, paramSet, impl):
    return f"{scheme}/bin/{paramSet}_{impl}_{testType}.bin"

def getFlash(binary):
    return f"st-flash --reset write {binary} 0x8000000"

def makeAll():
    if Settings.CLEAN == True:
        subprocess.check_call(f"make clean", shell=True)
    subprocess.check_call(f"make {schemeName} -j {Settings.JOBS} DEVICE={Settings.DEVICE}", shell=True)

def run_bench(scheme, paramSet, impl, outfile):
    binary = getBinary(scheme, paramSet, impl)

    if exists(binary) == 0:
        skipped.append(binary)
        print(f"skip {binary}")
        return b""

    try:
        subprocess.check_call(getFlash(binary), shell=True)
    except:
        print(f"openocd failed --> retry {binary}")
        return run_bench(scheme, paramSet, impl, outfile)

    runned.append(binary)

    print(Settings.SERIAL_DEVICE)

    # get serial output and wait for '+'
    with serial.Serial(Settings.SERIAL_DEVICE, Settings.BAUD_RATE, timeout=10) as dev:
        log = b""
        device_output = b''
        while device_output != b'#':
            device_output = dev.read()
            sys.stdout.buffer.write(device_output)
            sys.stdout.flush()
            log += device_output

        print(f"results for {paramSet} (impl={impl})", file=outfile)

        log = log.decode(errors="ignore")
        log = log.replace("=\n", "")
        log = log.replace('=', '')
        log = log.replace('#', '')
        log += '\n'
        outfile.write(log)
        outfile.flush()

with open(outFileName, "w") as outfile:

    now = datetime.datetime.now(datetime.timezone.utc)
    print(f"{testType} measurements written on {now}\n", file=outfile)

    makeAll()

    for paramSet in paramSetList:
        for imple in impleList:
            run_bench(schemeName, paramSet, cpu + imple, outfile)

    print("\n======== Run ========\n")
    print(str.join('\n', runned))
    print("\n======== Skipped ========\n")
    print(str.join('\n', skipped))

