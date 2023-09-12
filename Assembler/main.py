from functions import *
import sys
from os.path import exists

file_machineCode = "memory.dat"

if len(sys.argv) == 1:
    exit("no asm file provided")
file_asm = sys.argv[1]
if not exists(file_asm):
    exit("file {} doesn't exist".format(file_asm))
if len(sys.argv) >= 3:
    file_machineCode = sys.argv[2]

rawLines = []
with open(file_asm) as file:
    for line in file:
        rawLines.append(line)
lines = PreProcess(rawLines)

with open(file_machineCode, "w") as file:
    for line in lines:
        file.write(ProcessLine(line) + '\n')