ORG 0

	acall	CONFIGURE_LCD

KEYBOARD_LOOP:
	acall KEYBOARD
	;now, A has the key pressed
	ADD A, #48
	acall SEND_DATA
	sjmp KEYBOARD_LOOP




CONFIGURE_LCD:	;THIS SUBROUTINE SENDS THE INITIALIZATION COMMANDS TO THE LCD
	mov a,kb_over138H	;TWO LINES, 5X7 MATRIX
	acall SEND_COMMAND
	mov a,#0FH	;DISPLAY ON, CURSOR BLINKING
	acall SEND_COMMAND
	mov a,#06H	;INCREMENT CURSOR (SHIFT CURSOR TO RIGHT)
	acall SEND_COMMAND
	mov a,#01H	;CLEAR DISPLAY SCREEN
	acall SEND_COMMAND
	mov a,#80H	;FORCE CURSOR TO BEGINNING OF THE FIRST LINE
	acall SEND_COMMAND
	ret



SEND_COMMAND:
	mov p2,a		;THE COMMAND IS STORED IN A, SEND IT TO LCD
	clr p3.5		;RS=0 BEFORE SENDING COMMAND
	clr p3.6		;R/W=0 TO WRITE
	setb p3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	acall DELAY
	clr p3.7
	ret


SEND_DATA:
	mov p2,a		;SEND THE DATA STORED IN A TO LCD
	setb p3.5	;RS=1 BEFORE SENDING DATA
	clr p3.6		;R/W=0 TO WRITE
	setb p3.7	;SEND A HIGH TO LOW SIGNAL TO ENABLE PIN
	acall DELAY
	clr p3.7
	ret


DELAY:
	push 0
	push 1
	mov r0,#50
DELAY_OUTER_LOOP:
	mov r1,#255
	djnz r1,$
	djnz r0,DELAY_OUTER_LOOP
	pop 1
	pop 0
	ret


KEYBOARD: ;takes the key pressed from the keyboard and puts it to A
	mov	P0, #0ffh	;makes P0 input
K1:
	mov	P1, #0	;ground all rows
	mov	A, P0
	anl	A, #01111111B
	cjne	A, #01111111B, K1
K2:
	acall	DELAY
	mov	A, P0
	anl	A, #01111111B
	cjne	A, #01111111B, KB_OVER1
	sjmp	K2

KB_OVER1:
	mov	P1, #11111110B
	mov	A, P0
	anl	A, #01111111B
	cjne	A, #01111111B, ROW_0
	mov	P1, #11111101B
	mov	A, P0
	anl	A, #01111111B
	cjne	A, #01111111B, ROW_1
	mov	P1, #11111011B
	mov	A, P0
	anl	A, #01111111B
	cjne	A, #01111111B, ROW_2
	mov	P1, #11110111B
	mov	A, P0
	anl	A, #01111111B
	cjne	A, #01111111B, ROW_3
	ljmp	K2
	
ROW_0:
	MOV R2, #00
	sjmp	KB_FIND
ROW_1:
	MOV R2, #7
	sjmp	KB_FIND
ROW_2:
	MOV R2, #14
	sjmp	KB_FIND
ROW_3:
	MOV R2, #21
KB_FIND:
	RL	A
	JNB ACC.7,KB_MATCH
	inc	R2
	sjmp	KB_FIND
KB_MATCH:
	MOV A,R2
	ret


END

