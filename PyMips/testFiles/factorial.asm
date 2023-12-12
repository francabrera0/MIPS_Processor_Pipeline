
ADDI r26,r0,12 #Numero a calcular factorial

ADDI r26,r26,1
ADDI r25,r0,1 #Contador
ADDI r24,r0,1 #Resultado

FLOOP: BEQ r25,r26,FEND
	ADDI r29,r24,0 #Cargar operando 1 mul
	ADDI r30,r25,0 #Carcar operando 2 mul
	JAL MUL
	ADDI r25,r25,1 #Aumento Contador
	J FLOOP	
	ADDI r24,r27,0
FEND: HALT

#///////////////////////////////////////////////////////////////////

MUL: ADDI r27,r0,0 #Resultado
ADDI r28,r0,0 #Contador

MLOOP: BEQ r28,r30,MEND
	ADDI r28,r28,1
	J MLOOP
	ADDU r27,r27,r29
MEND: JR r31
NOP