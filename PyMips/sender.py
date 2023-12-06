import serial


sender = serial.Serial("/dev/pts/2", 115200)

n = 2

for i in range (128):
    if (i == 12):
        sender.write(bytes([n*i]))
    else:
        sender.write(bytes([i]))

for i in range (128):
    if (i == 28):
        sender.write(bytes([n*i]))
    else:
        sender.write(bytes([i]))

for i in range (4):
    sender.write(bytes([n*i]))

