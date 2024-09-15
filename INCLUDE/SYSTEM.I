; Include: SYSTEM
; Version: 0.1
; Date:    2024-09-12

	section	text

system_exit:

	move.w	d0,-(sp)
	move.w	#$4c,-(sp)	; term
	trap	#1

system_vbl:

	move.w	#36,-(sp)	;  wvbl
	trap	#14
	addq.l	#2,sp

	rts

system_shrink:

	move.l	#$0100,d0	; base size
	add.l	$c(a0),d0	; text size
	add.l	$14(a0),d0	; data size
	add.l	$1c(a0),d0	; bss size
	move.l	d0,-(sp)
	move.l	a0,-(sp)
	clr.w	-(sp)
	move.w	#$4a,-(sp)	; setblock
	trap	#1
	lea	12(sp),sp

	rts
