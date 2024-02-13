from dicts import *

def PreProcess(lines):
    global symbolsList
    postProcessLines = []
    counter = 0

    for line in lines:
        line = line.split("#", 1)[0] #gets rid of comments
        line = line.strip(" ")
        
        #processing for jump keywords
        checkStartJump = line.find(":")
        if checkStartJump != -1:
            symbol = line.split(":", 1)[0].strip(":").lstrip(" ")
            symbolsList[symbol] = str(counter)  #maps jump label to instruction address                      
            line = line[checkStartJump + 1:len(line) - 1] 

        if len(line) > 0:
            line = line.strip(" ")    
            postProcessLines.append(line)
            counter = counter + 1

    return postProcessLines

def ProcessLine(line, cnt):
    global instructionList
    global funcList
    splitLine = line.split(" ", 1)

    instruction = splitLine[0].lower()
    if instruction not in instructionList:
        exit("invalid instruction: {}".format(instruction))

    [opCode, instrType] = instructionList[instruction] 

    match instrType:
        case "R":
            registers = splitLine[1].replace(" ", "")
            function = funcList[instruction]
            
            if(instruction == "jr"):
                if registers.count("$") != 1:
                    exit("instruction jr takes 1 register argument")
                [regS, regT, regD] = [registers, "$0", "$0"]
            else:
                if registers.count("$") < 3:
                    exit("instruction {} takes 3 register arguments".format(splitLine[0]))
                [regS, regT, regD] = [registers.split(",")[1], registers.split(",")[2], registers.split(",")[0]]

            return RType(function, regS, regT, regD);
        case "I":
            arguments = splitLine[1].replace(" ", "")
            nrCommas = line.count(",")

            if arguments.count("$") < 2:
                exit("instruction {} takes 2 register arguments".format(instruction))
            if(nrCommas == 2):
                [regS, immediate, regD] = [arguments.split(",")[1], arguments.split(",")[2], arguments.split(",")[0]]
            else: #for lw and sw
                if instruction != "lw" and instruction != "sw":
                    exit("{} takes 3 arguments".format(instruction))
                regD = arguments.split(",")[0]
                arguments = arguments.split(",")[1]
                [regS, immediate] = [arguments.split("(")[1].replace(")", ""), arguments.split("(")[0]]
            
            if immediate == "\n":
                exit("{} takes one immediate argument".format(instruction))
            return IType(opCode, regS, regD, immediate, cnt)
        case "J":
            jumpAddr = splitLine[1]

            return JType(opCode, jumpAddr)
        
#for working with negative immediates
def ProcessNumber(numberString):

    if numberString[0] == "-":
        if numberString[1:len(numberString)].isdigit():
            return bin(int(numberString) & 0xffff).replace("0b", "")
        else:
            return -1
    elif numberString.isdigit():
        return format(int(numberString) , 'b')
    else:
        return -1

def DecodeRegister(reg):
    global regList
    reg = reg.strip("\n")

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
    if(instruction == "000000"):
        shamt = format(int(regT), "b")
        rs = "00000"
        rt = DecodeRegister(regS);
        rd = DecodeRegister(regD);
    else:
        rs = DecodeRegister(regS)
        rt = DecodeRegister(regT)
        rd = DecodeRegister(regD)
    
    return "000000" + rs + rt + rd + shamt + instruction  

def IType(instruction, regS, regD, immediate, position):
    global symbolsList
    rs = DecodeRegister(regS)
    rd = DecodeRegister(regD)
    immediate = immediate.strip("\n")
    isNumber = ProcessNumber(immediate)

    if isNumber == -1: #jump labels for beq
        if immediate not in symbolsList:
            exit("invalid jump label: {}".format(immediate))

        jumpAddr = symbolsList[immediate]
        offset = int(jumpAddr) - position - 1
        immediate = format(offset, 'b')
    else:
        immediate = isNumber

    return instruction + rs + rd + (16 - len(immediate)) * "0" + immediate

def JType(instruction, jumpAddr):
    global symbolsList
    jumpAddr = jumpAddr.strip("\n")
    
    if(jumpAddr.isdigit()):
        jumpAddr = format(int(jumpAddr), 'b')
    else:
        if jumpAddr not in symbolsList:
            exit("invalid jump label: {}".format(jumpAddr))
        jumpAddr = format(int(symbolsList[jumpAddr]), 'b')

    return instruction + (26 - len(jumpAddr)) * "0" + jumpAddr