import sys
from PySide6.QtWidgets import QApplication, QMainWindow, QWidget, QTextEdit, QTableWidget, QPushButton, QGridLayout, QTableWidgetItem, QFileDialog
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
    serialComPort = serial.Serial("COM9", 115200, timeout=2)

    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):

        self.setWindowTitle("MIPS IDE")

        centralWidget = QWidget()
        self.setCentralWidget(centralWidget)

        self.codeEditor = QTextEdit()
        
        self.codeEditor.setMinimumWidth(600)
        self.codeEditor.setMinimumHeight(300)

        self.assemblyCode = QTextEdit()
        self.assemblyCode.setMinimumHeight(300)
        
        self.registerTable = QTableWidget(32, 1)
        self.registerTable.setHorizontalHeaderLabels(["Registros"])
        self.registerTable.setMaximumWidth(150)
        self.setTableVerticalHeader(self.registerTable, 32)

        self.memoryTable = QTableWidget(32, 1) 
        self.memoryTable.setHorizontalHeaderLabels(["Memoria"])
        self.memoryTable.setMaximumWidth(150)
        self.setTableVerticalHeader(self.memoryTable, 32)

        self.programCounter = QTableWidget(1, 1)
        self.programCounter.setHorizontalHeaderLabels(["Program Counter"])
        self.programCounter.setMaximumWidth(150)
        self.setTableVerticalHeader(self.programCounter, 1)

        buildButton = QPushButton("Build")
        buildButton.clicked.connect(self.handleBuild)
        programButton = QPushButton("Program")
        programButton.clicked.connect(self.handleProgram)
        stepButton = QPushButton("Step")
        stepButton.clicked.connect(self.handleStep)
        runButton = QPushButton("Run")
        runButton.clicked.connect(self.handleRun)
        resetButton = QPushButton("Reset")
        resetButton.clicked.connect(self.handleReset)
        saveButton = QPushButton("Save")
        saveButton.clicked.connect(self.saveSourceCode)
        openButton = QPushButton("Open")
        openButton.clicked.connect(self.openFile)

        layout = QGridLayout()
        centralWidget.setLayout(layout)

        layout.addWidget(saveButton, 0, 0, 1, 1)
        layout.addWidget(openButton, 0, 1, 1, 1)
        layout.addWidget(self.codeEditor, 1, 0, 4, 2)
        layout.addWidget(self.assemblyCode, 5, 0, 4, 2)

        layout.addWidget(buildButton, 1, 2, 1, 1)
        layout.addWidget(programButton, 2, 2, 1, 1)
        layout.addWidget(resetButton, 3, 2, 1, 1)
        layout.addWidget(stepButton, 5, 2, 1, 1)
        layout.addWidget(runButton, 7, 2, 1, 1)
        
        layout.addWidget(self.registerTable, 0, 3, 9, 1)
        layout.addWidget(self.memoryTable, 0, 4, 9, 1)
        layout.addWidget(self.programCounter, 0, 5, 5, 1)
    

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

    # Send a reset command
    def handleReset(self):
        self.serialComPort.write(bytes.fromhex('69'))


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
        else:
            print("Time out")
        

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

    def saveSourceCode(self):
        fileDialog = QFileDialog()
        fileDialog.setFileMode(QFileDialog.AnyFile)
        fileDialog.setAcceptMode(QFileDialog.AcceptSave)
        fileDialog.setNameFilter("*.asm")
        if fileDialog.exec():
            filePath = fileDialog.selectedFiles()[0]
            with open(filePath, 'w') as file:
                file.write(self.codeEditor.toPlainText())

    def openFile(self):
        fileDialog = QFileDialog()
        fileDialog.setFileMode(QFileDialog.ExistingFile)
        fileDialog.setNameFilter("*.asm")
        if fileDialog.exec():
            filePath = fileDialog.selectedFiles()[0]
            with open(filePath, 'r') as file:
                content = file.read()
                self.codeEditor.setPlainText(content)

    def setTableVerticalHeader(self, table, cells):
        for i in range(cells):
            table.setItem(i,0, QTableWidgetItem(""))
            item = QTableWidgetItem()
            item.setData(0,i)
            table.setVerticalHeaderItem(i,item)

def main():
    app = QApplication(sys.argv)
    mipsIde = mipsIDE()
    sys.exit(app.exec())

if __name__ == '__main__':
    main()