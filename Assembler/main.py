from functions import *
import sys #for getting command line arguments
from os.path import exists #for checking if file exists

file_machineCode = "memfile.dat" 

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

cnt = 0 #for computing branch offset
with open(file_machineCode, "w") as file:
    for line in lines:
        file.write(ProcessLine(line, cnt) + '\n')
        cnt = cnt + 1