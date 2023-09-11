from dicts import *
from functions import *

file_asm = "test.txt"
file_binary = "memory.dat"

rawLines = []
with open(file_asm) as file:
    for line in file:
        rawLines.append(line)

lines = PreProcess(rawLines)

for line in lines:
    machineCode = ProcessLine(line)
    print(machineCode)

