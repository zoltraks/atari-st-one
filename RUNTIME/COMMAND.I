; Include: COMMAND
; Version: 0.3
; Date:    2024-10-05
; Author:  ZoltarX/NG

	section	text

; Save argument line
;
;   a0    - TPA
;

command_parse:

	tst.b	128(a0)		; cmdlin
	bne	.have
	clr.w	command_empty
	move.l	#command_empty,command_line

	rts

.have:

	movem.l	d0/a0,-(sp)

	move.l	a0,d0
	addi.l	#129,d0

.loop:

	move.l	d0,a0
	cmpi.b	#32,(a0)
	beq	.skip
	cmpi.b	#9,(a0)
	beq	.skip

	move.l	d0,command_line

	movem.l	(sp)+,d0/a0

	rts

.skip:

	addi.l	#1,d0
	bra	.loop

	section	bss

command_line:

	ds.l	1

command_empty:

	ds.w	1

	section	text
