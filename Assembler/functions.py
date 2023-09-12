from dicts import *

def PreProcess(lines):
    global symbolsList
    postProcessLines = []
    counter = 0

    for line in lines:

        line = line.lower()
        line = line.split("#", 1)[0]                                #gets rid of comments
        line = line.strip(" ")

        checkStartJump = line.find(":")
        if checkStartJump != -1:                                    #processing for jump keywords
            symbol = line.split(":", 1)[0].strip(":").lstrip(" ")
            symbolsList[symbol] = str(counter)                       
            line = line[checkStartJump + 1:len(line) - 1] 

        if len(line) > 0:
            line = line.strip(" ")    
            postProcessLines.append(line)
            counter = counter + 1

    return postProcessLines

def ProcessLine(line):
    global instructionList
    global funcList

    instruction = line.split(" ")[0]
    if instruction not in instructionList:
        exit("invalid instruction: {}".format(instruction))

    [opCode, instrType] = instructionList[instruction] 

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
        digit = int(reg.replace("$", ""))
        if digit > 31:
            exit("invalid register: {}".format(reg))
        digit = format(digit, "b")
    else:
        if reg not in regList:
            exit("invalid register: {}".format(reg))
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
    rs = DecodeRegister(regS)
    rd = DecodeRegister(regD)

    if(immediate.isdigit()):
        immediate = format(int(immediate), 'b')
    else:
        immediate = format(int(symbolsList[immediate.strip("\n")]), 'b')

    return instruction + rs + rd + (16 - len(immediate)) * "0" + immediate

def JType(instruction, offset):
    global symbolsList

    offset.strip(" ")
    offset = offset.strip("\n")
    
    if(offset.isdigit()):
        offset = format(int(offset), 'b')
    else:
        if offset not in symbolsList:
            exit("invalid jump label: {}".format(offset))
        offset = format(int(symbolsList[offset]), 'b')

    return instruction + (26 - len(offset)) * "0" + offset