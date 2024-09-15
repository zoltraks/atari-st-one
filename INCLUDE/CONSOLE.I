; Include: CONSOLE
; Version: 0.3
; Date:    2024-09-14

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

	movem.l	a0,-(sp)

	move.l	a0,-(sp)
	move.w	#9,-(sp)	; print
	trap	#1
	addq.l	#6,sp

	movem.l	(sp)+,a0

	rts

console_get:

	move.w	#1,-(sp)	; conin
	trap	#1
	addq.l	#2,sp

	rts

console_key:

	move.w	#7,-(sp)	; direct conin
	trap	#1
	addq.l	#2,sp
	
	rts

console_up:

	move.w	#27,-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	move.w	#'A',-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	addq.l	#8,sp

	rts

console_down:

	move.w	#27,-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	move.w	#'B',-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	addq.l	#8,sp

	rts
