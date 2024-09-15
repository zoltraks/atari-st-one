; Include: COMMAND
; Version: 0.1
; Date:    2024-09-14

	section	text

; Save argument line
;
;   a0    - TPA
;

command_parse:

	move.l	#command_empty,command_line

	tst.b	128(a0)		; cmdlin
	bne	.yahoo

	rts

.yahoo:

	move.l	d0,-(sp)

	move.l	a0,d0
	addi.l	#129,d0
	move.l	d0,command_line

	move.l	(sp)+,d0

	rts

	section	bss

	even

command_line:

	ds.l	1

	section	data

	even

command_empty:

	dc.b	0

	section	text
