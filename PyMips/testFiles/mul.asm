
ADDI r29,r0,9 #Operando 1
ADDI r30,r0,3 #Opreando 2

JAL MUL
NOP
HALT

	MUL: ADDI r27,r0,0 #Resultado
	ADDI r28,r0,0 #Contador

	LOOP: BEQ r28,r30,END
		ADDI r28,r28,1
		J LOOP
		ADDU r27,r27,r29
	END: JR r31
	NOP