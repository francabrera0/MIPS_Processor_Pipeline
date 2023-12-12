#Supongo que los registros arrancan en 0
#r0 -> Max
#r1 -> Contador
#r2 -> Valor anterior
#r3 -> Valor actual
#r4 -> Temporal

ADDI r5, r0, 10 #Max en 10
ADDI r3, r0, 1  #Valor actual en 1
ADDI r1,r0, 0 #0 en r1
ADDI r2,r0, 0 #0 en r2
ADDI r7,r0, 1 #1 en r7

FIBONACCI: BEQ r1, r5, END
ADDI r1, r1, 1 #Aumento el contador

ADDU r4, r3, r2 # Temporal = Actual + Anterior
ADDI r2, r3, 0  # Anterior = Actual
ADDI r3, r4, 0  # Actual = Temporal

SUBU r6,r1,r7
SLL r6, r6, 2
J FIBONACCI #Hace el loop
END: SW r3, 0(r6) 
HALT
NOP