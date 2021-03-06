	.data
	.balign	4
ErrMsg:	.asciz	"Setup didn't work...\n"
pin:	.int	7
i:	.int	0
delayMs	.int	250
OUTPUT	=	1

	.text
	.global	main
	.extern	printf
	.extern	wiringPiSetup
	.extern	delay
	.extern	digitalWrite
	.extern	pinMode

main:	PUSH	{ip,lr}
	BL	wiringPiSetup
	MOV	R1,#-1
	CMP	R0,R1
	BNE	init
	LDR	R0, =ErrMsg
	BL	printf
	B	done

init:
	LDR	R0, =pin
	LDR	R0, [R0]
	MOV	R1, #OUTPUT
	BL	pinMode

	LDR	R4, =i
	LDR	R4, [R4]
	MOV	R5, #40

forLoop:
	CMP	R4,R5
	BGT	done

	@digitalWrite(pin,1)
	LDR	R0, =pin
	LDR	R0, [R0]
	MOV	R1, #1
	BL	digitalWrite

	@delay(delayMs)
	LDR	R0, =delayMs
	LDR	R0, [R0]
	BL	delay
	
	@digitalWrite(pin,0)
	LDR	R0, =pin
	LDR	R0, [R0]
	MOV	R1, #0
	BL	digitalWrite
	
	@delay
	LDR	R0, =delayMs
	LDR	R0, [R0]
	BL	delay

	ADD	R4, #1
	B	forLoop
done:
	POP	{ip,pc}
	