#En el registro 1 llega el numero al que se le hace el factorial

ADDI r1, r0, 1
ADDI r2, r0, 1
ADDI r3, r0, 0

ADDI r5, r0, 4

LOOP: ADDU r3, r3, r1
ADDI r1, r1, 1
ADDI r2, r2, 1
BNE r2, r5, LOOP
NOP
HALT