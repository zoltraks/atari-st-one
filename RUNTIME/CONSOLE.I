; Include: CONSOLE
; Version: 0.8
; Date:    2024-10-18
; Author:  ZoltarX/NG

	section	text

; Clear console window
;
; Please ensure hidden mouse cursor before calling :-)

console_clear:

	move.w	#27,-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	move.w	#'E',-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	addq.l	#8,sp

	rts

; Print new line

console_line:

	movem.l	d0-1/a0,-(sp)

	move.w	#13,-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	move.w	#10,-(sp)
	move.w	#2,-(sp)	; conout
	trap	#1
	addq.l	#8,sp

	movem.l	(sp)+,d0-1/a0

	rts

; Write text out
;
; Input
;
;	a0	- text address

console_print:

	movem.l	d0/a0,-(sp)

	move.l	a0,-(sp)
	move.w	#9,-(sp)	; print
	trap	#1
	addq.l	#6,sp

	movem.l	(sp)+,d0/a0

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

; Check if key was pressed
;
; Output
;
;	d0	- zero when key was not pressed
;	Z	- set when key was not pressed
;
; Example
;
;	bsr	console_has_key
;	bne	.key_pressed

console_has_key:

	move.w	#2,-(sp)	; CON:
	move.w	#1,-(sp)	; bconstat
	trap	#13
	addq.l	#4,sp

	tst.b	d0

	rts

console_input:

	move.w	#0,-(sp)
	move.w	#1,-(sp)
	move.w	#21,-(sp)	; cursconf
	trap	#14
	addq.l	#6,sp

	move.b	#255,console_buffer
	move.l	#console_buffer,-(sp)
	move.w	#$0a,-(sp)	; readline
	trap	#1
	addq.l	#6,sp

	move.w	d0,-(sp)
	
	move.w	#0,-(sp)
	move.w	#0,-(sp)
	move.w	#21,-(sp)	; cursconf
	trap	#14
	addq.l	#6,sp

	lea	console_buffer+3,a0
	move.w	(sp)+,d0
	add.l	d0,a0
	move.b	#'$',(a0)
	lea	console_buffer+2,a0

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

	section	bss

console_buffer:

	ds.b	258

	section	text
