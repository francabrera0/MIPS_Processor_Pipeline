import sys
from PySide6.QtWidgets import QApplication, QMainWindow, QWidget, QTextEdit, QTableWidget, QPushButton, QGridLayout, QTableWidgetItem
from PySide6.QtGui import QColor

from assembler.assemblyParser import assemblyParser
from assembler.instructionTable import instructionTable
from assembler.registerTable import registerTable

import serial

class mipsIDE(QMainWindow):

    codeEditor = None
    assemblyCode = None
    parser = assemblyParser(instructionTable, registerTable, 4)
    programValid = False
    serialComPort = serial.Serial("/dev/pts/1", 115200)

    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):

        self.setWindowTitle("MIPS IDE")

        centralWidget = QWidget()
        self.setCentralWidget(centralWidget)

        self.codeEditor = QTextEdit()
        self.codeEditor.setText("ADDU r10, r0, r5 \nSW r20, r0, 6 \nLW  r31, r0, 6 \nBEQ r8, r10, SALTO \nNOP \nNOP \nNOP \nOR r11, r0, r5 \nSALTO: AND r11, r0, r5 \nSLL r20, r20, 2 \nSLLV r8, r8, r0 \nHALT")
        
        self.codeEditor.setMinimumWidth(600)
        self.codeEditor.setMinimumHeight(300)

        self.assemblyCode = QTextEdit()
        self.assemblyCode.setMinimumHeight(300)
        
        self.registerTable = QTableWidget(32, 1)
        self.registerTable.setHorizontalHeaderLabels(["Registros"])
        self.registerTable.setMaximumWidth(150)
        
        self.memoryTable = QTableWidget(32, 1) 
        self.memoryTable.setHorizontalHeaderLabels(["Memoria"])
        self.memoryTable.setMaximumWidth(150)

        self.programCounter = QTableWidget(1, 1)
        self.programCounter.setHorizontalHeaderLabels(["Program Counter"])
        self.programCounter.setMaximumWidth(150)

        buildButton = QPushButton("Build")
        buildButton.clicked.connect(self.handleBuild)
        programButton = QPushButton("Program")
        programButton.clicked.connect(self.handleProgram)
        stepButton = QPushButton("Step")
        stepButton.clicked.connect(self.handleStep)
        runButton = QPushButton("Run")
        runButton.clicked.connect(self.handleRun)

        layout = QGridLayout()
        centralWidget.setLayout(layout)

        layout.addWidget(self.codeEditor, 0, 0, 3, 2)
        layout.addWidget(self.assemblyCode, 3, 0, 2, 2)
        layout.addWidget(self.registerTable, 0, 3, 5, 1)
        layout.addWidget(self.memoryTable, 0, 4, 5, 1)
        layout.addWidget(self.programCounter, 0, 5, 5, 1)
        

        layout.addWidget(buildButton, 0, 2)
        layout.addWidget(programButton, 2, 2)
        layout.addWidget(stepButton, 3, 2)
        layout.addWidget(runButton, 4, 2)

        self.showMaximized()

    # Assembly source code
    def handleBuild(self):
        lines = self.codeEditor.toPlainText().splitlines()
        result = self.parser.firstPass(lines)
        if result != 0:
            self.assemblyCode.setText(result)
            self.programValid = False
        else:
            self.parser.asmToMachineCode(lines)
            self.assemblyCode.setText('')
            for string in self.parser.outputArray:
                self.assemblyCode.append(str(string))
            self.programValid = True

    # Send a step command
    def handleStep(self):
        self.serialComPort.write(bytes.fromhex('12'))
        self.updateTables()

    # Send a run command
    def handleRun(self):
        self.serialComPort.write(bytes.fromhex('54'))
        self.updateTables()

    def handleProgram(self):
        if(self.programValid):

            for i in range (0, len(self.parser.instructions), 4):
                self.serialComPort.write(bytes.fromhex('23'))

                for j in range (3, -1, -1):
                    index = i+j
                    if (index < len(self.parser.instructions)):
                        byte = int(self.parser.instructions[index], 16)
                        self.serialComPort.write(bytes([byte]))
                    else: 
                        break
        else:
            print("Program not valid")


    def updateTables(self):
        data = self.serialComPort.read(260)

        if len(data) == 260:
            self.updateTable(data, self.registerTable, 0, 32)
            self.updateTable(data, self.memoryTable, 32, 64)
            self.updateTable(data, self.programCounter, 64, 65)

    def updateTable(self, data, table, startIndex, endIndex):
        for i in range(startIndex, endIndex):
            itemIndex = i - startIndex
            value = 0
            for j in range(4):
                byte = data[i * 4 + j]
                value += byte << (j * 8)

            item = QTableWidgetItem(hex(value))
            currentItem = table.item(itemIndex, 0)
            if (currentItem is not None and currentItem.text() != item.text()):
                item.setBackground(QColor(255, 165, 0))
            else:
                item.setBackground(QColor(0, 0, 0, 0))

            table.setItem(itemIndex, 0, item)


def main():
    app = QApplication(sys.argv)
    mipsIde = mipsIDE()
    sys.exit(app.exec())

if __name__ == '__main__':
    main()