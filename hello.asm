STKSEG SEGMENT STACK
DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
	MSG DB "Hello World$"
DATASEG ENDS

CODESEG SEGMENT
	ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC FAR
	MOV AX,DATASEG
	MOV DS,AX
	MOV AH,9
	MOV DX,OFFSET MSG
	INT 21H
	MOV AX,4C00H
	INT 21H
MAIN ENDP
CODESEG ENDS
	END MAIN