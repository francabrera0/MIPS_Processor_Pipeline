from assemblyParser import assemblyParser
from instructionTable import instructionTable
from registerTable import registerTable

import sys

def main(argv):
    file = argv
    
    asm = open(file)
    lines = asm.readlines()
    parser = assemblyParser(instructionTable, registerTable, 4)
    parser.firstPass(lines)
    parser.asmToMachineCode(lines)

    for out in parser.outputArray:
        print(out)


if __name__ == '__main__':
    main(sys.argv[1])