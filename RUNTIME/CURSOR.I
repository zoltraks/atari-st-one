; Include: CURSOR
; Date:    2024-09-15

	section	text

cursor_disable:

	move.w	#0,d0
	bra	cursor_function

cursor_enable:

	move.w	#1,d0
	bra	cursor_function

cursor_flash:

	move.w	#2,d0
	bra	cursor_function

cursor_steady:

	move.w	#3,d0
	bra	cursor_function

cursor_function:

	move.w	#0,-(sp)
	move.w	d0,-(sp)
	move.w	#21,-(sp)	; cursconf
	trap	#14
	addq.l	#6,sp

	rts

