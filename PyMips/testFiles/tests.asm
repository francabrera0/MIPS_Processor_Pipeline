#Supongo que los registros arrancan en 0
#r0 -> Max
#r1 -> Contador
#r2 -> Valor anterior
#r3 -> Valor actual
#r4 -> Temporal

ADDI r0, r0, 10 #Max en 10
ADDI r3, r3, 1  #Valor actual en 1

FIBONACCI: BEQ r1, r0, END
ADDI r1, r1, 1 #Aumento el contador

ADDU r4, r3, r2 # Temporal = Actual + Anterior
ADDI r2, r3, 0  # Anterior = Actual
ADDI r3, r4, 0  # Actual = Temporal

J FIBONACCI #Hace el loop

END: SW r3, 0(r4) 