from dicts import *

def PreProcess(lines):
    global symbolsList

    postProcessLines = []
    counter = 0

    for line in lines:
        line = line.lower()
        line = line.split("#", 1)[0] #gets rid of comments
        if len(line) > 0:
            checkStartJump = line.find(":")
            if checkStartJump != -1: 
                symbol = line.split(":", 1)[0].strip(":").lstrip(" ")
                symbolsList[symbol] = str(counter)              #maps jumps to instruction number
                line = line[checkStartJump + 1:len(line) - 1]            #gets rid of the jump start

            line = line.strip(" ")      #gets rid of leading whitespaces
            line = line.lower()
            postProcessLines.append(line)
        counter = counter + 1

    return postProcessLines

def ProcessLine(line):
    [opCode, instrType] = instructionList[line.split(" ")[0]] 

    match instrType:
        case "R":
            splitLine = line.split(" ", 1)
            instruction = funcList[splitLine[0]]
            registers = splitLine[1].replace(" ", "")
            [regS, regT, regD] = [registers.split(",")[1], registers.split(",")[2], registers.split(",")[0]]

            return RType(instruction, regS, regT, regD);
        case "I":
            splitLine = line.split(" ", 1)[1]
            splitLine = splitLine.replace(" ", "")
            nrCommas = line.count(",")
            if(nrCommas == 2):
                [regS, immediate, regD] = [splitLine.split(",")[1], splitLine.split(",")[2], splitLine.split(",")[0]]
            else:
                regD = splitLine.split(",")[0]
                splitLine = splitLine.split(",")[1]
                [regS, immediate] = [splitLine.split("(")[1].strip("()"), splitLine.split("(")[0]]
            
            return IType(opCode, regS, regD, immediate)
        case "J":
            offset = line.split(" ", 1)[1]

            return JType(opCode, offset);
            
def DecodeRegister(reg):
    global regList;
    if(reg[1].isdigit()):
        digit = format(int(reg.replace("$", "")), 'b')
    else:
        return regList[reg];
    
    return (5 - len(digit)) * "0" + digit

def RType(instruction, regS, regT, regD):
    
    shamt = "00000"

    rs = DecodeRegister(regS)
    rt = DecodeRegister(regT)
    rd = DecodeRegister(regD)
    
    return "000000" + rs + rt + rd + shamt + instruction  

def IType(instruction, regS, regD, immediate):

    global symbolsList
    if(immediate.isdigit()):
        immediate = format(int(immediate), 'b')
    else:
        immediate = format(int(symbolsList[immediate]), 'b')

    rs = DecodeRegister(regS)
    rd = DecodeRegister(regD)
    return instruction + rs + rd + (16 - len(immediate)) * "0" + immediate

def JType(instruction, offset):

    global symbolsList

    if(offset.isdigit()):
        offset = format(int(offset), 'b')
    else:
        offset = format(int(symbolsList[offset]), 'b')
    return instruction + (26 - len(offset)) * "0" + offset