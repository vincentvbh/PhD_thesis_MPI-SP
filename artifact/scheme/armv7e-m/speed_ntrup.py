#!/usr/bin/env python3

import datetime
import subprocess
import sys
from os.path import exists

import serial
import numpy as np
from config import Settings

testType = "speed"
schemeName = "ntrup"
outFileName = f"{schemeName}/speed.txt"
iterations = 100
testedList = [["keygen", "keypair cycles:"],
              ["encap", "encaps cycles:"],
              ["decap", "decaps cycles:"]
             ]
paramSetList = ["sntrup761"]
impleList = ["old_1530", "old_1536"]
cpu = ""

runned = []
skipped = []

def toLog(name, value, k=None):
  if value > 10000:
    value = f"{round(value/1000)}k"
  else:
    value = f"{value}"
  return f"{name}: {value}\n"

def getBinary(scheme, paramSet, impl):
    return f"{scheme}/bin/{paramSet}_{impl}_{testType}.bin"

def getFlash(binary):
    return f"st-flash --reset write {binary} 0x8000000"

def makeAll():
    if Settings.CLEAN == True:
        subprocess.check_call(f"make clean", shell=True)
    subprocess.check_call(f"make {schemeName} -j {Settings.JOBS} ITERATIONS={iterations} DEVICE={Settings.DEVICE}", shell=True)

def run_bench(scheme, paramSet, impl):
    binary = getBinary(scheme, paramSet, impl)

    if exists(binary) == 0:
        skipped.append(binary)
        print(f"skip {binary}")
        return b""

    try:
        subprocess.check_call(getFlash(binary), shell=True)
    except:
        print(f"openocd failed --> retry {binary}")
        return run_bench(scheme, paramSet, impl)

    runned.append(binary)

    # get serial output and wait for '+'
    with serial.Serial(Settings.SERIAL_DEVICE, Settings.BAUD_RATE, timeout=10) as dev:
        logs = []
        iteration = 0
        log = b""
        while iteration < iterations:
            device_output = dev.read()
            if device_output == b'':
                print(f"timeout --> retry {binary}")
                return run_bench(scheme, paramSet, impl)
            sys.stdout.buffer.write(device_output)
            sys.stdout.flush()
            log += device_output
            if device_output == b'+':
                logs.append(log)
                log = b""
                iteration += 1
    return logs


def parseLog(log, ignoreErrors):
    log = log.decode(errors="ignore")
    if "error" in log.lower() and not ignoreErrors:
        raise Exception("error in scheme. this is very bad.")
    lines = str(log).splitlines()

    def get(lines, key):
        if key in lines:
            return int(lines[1+lines.index(key)])
        else:
            return None

    def cleanNullTerms(d):
        return {
            k:v
            for k, v in d.items()
            if v is not None
        }

    return cleanNullTerms({
            k: get(lines, v)
            for k, v in testedList
    })

def average(results):
    avgs = dict()
    for key in results[0].keys():
        avgs[key] = int(np.array([results[i][key] for i in range(len(results))]).mean())
    return avgs


def bench(scheme, paramSet, texName, impl, outfile, ignoreErrors=False):
    logs    = run_bench(scheme, paramSet, impl)
    if logs == b"":
        return
    results = []
    for log in logs:
        try:
            result = parseLog(log, ignoreErrors)
        except:
            breakpoint()
            print("parsing log failed -> retry")
            return bench(scheme, paramSet, texName, impl, outfile)
        results.append(result)

    avgResults = average(results)
    print(f"results for {paramSet} (impl={impl})", file=outfile)

    for key, value in avgResults.items():
        macro = toLog(f"{texName}{key}", value)
        print(macro.strip())
        print(macro, end='', file=outfile)
    print('', file=outfile, flush=True)

with open(outFileName, "w") as outfile:

    now = datetime.datetime.now(datetime.timezone.utc)
    print(f"{testType} measurements written on {now}; iterations={iterations}\n", file=outfile)

    makeAll()

    for paramSet in paramSetList:
        for imple in impleList:
            bench(schemeName, paramSet, paramSet + cpu + imple, cpu + imple, outfile)

    print("\n======== Run ========\n")
    print(str.join('\n', runned))
    print("\n======== Skipped ========\n")
    print(str.join('\n', skipped))

