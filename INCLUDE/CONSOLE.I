; Include: CONSOLE
; Version: 0.1
; Date:    2024-09-12

	section	text

console_clear:

	move.w	#27,-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	move.w	#'E',-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	addq.l	#8,sp

	rts

console_line:

	move.w	#13,-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	move.w	#10,-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	addq.l	#8,sp

	rts

console_print:

	move.l	a0,-(sp)
	move.w	#9,-(sp)	; print
	trap	#1
	addq.l	#6,sp

	rts
