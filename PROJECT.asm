	ORG 0000H
	MOV TMOD, #01H
BACK:	MOV TH0, #11110110B
	MOV TL0, #11010010B
	SETB TR0
	SETB P1.0
	JNB TF0, $
	CLR P1.0
	CLR TR0
	CLR TF0
	MOV TH0, #11110110B
	MOV TL0, #11010010B
	SETB TR0
	JNB TF0, $
	CLR TR0
	CLR TF0
	SJMP BACK

	END
	