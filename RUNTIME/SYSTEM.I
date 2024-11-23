; Include: SYSTEM
; Version: 0.4
; Date:    2024-11-23

	section	text

; Exit process with status code
;
;   d0.w - status code
;
; Example
;
;	clr.w	d0
;	bra	system_exit

system_exit:

	move.w	d0,-(sp)
	move.w	#$4c,-(sp)	; term
	trap	#1

; Wait for VBL

system_vbl:

	move.w	#37,-(sp)	;  wvbl
	trap	#14
	addq.l	#2,sp

	rts

; Shrink memory after start
;
;   a0   - TPA
;
; Output
;
;   a0 - text buffer
;
; Example
;
;	movea.l	4(sp),a0	; TPA
;	bsr	system_shrink

system_shrink:

	move.l	#$0100,d0	; base size
	add.l	$c(a0),d0	; text size
	add.l	$14(a0),d0	; data size
	add.l	$1c(a0),d0	; heap size
	movem.l	d0/a0,-(sp)
	move.l	d0,-(sp)
	move.l	a0,-(sp)
	clr.w	-(sp)
	move.w	#$4a,-(sp)	; setblock
	trap	#1
	lea	12(sp),sp
	movem.l	(sp)+,d0/a0

	rts

; Wait for specified amount of milliseconds (rounded to 5ms)
;
;	d0	- amount of milliseconds

system_wait:

	subi.w	#1,d0
	bpl	.next
	addi.w	#1,d0

	rts

.next

	movem.l	d0-2/a0-1,-(sp)

	move.l	d0,d2

	clr.l	-(sp)
	move.w	#32,-(sp)	; super
	trap	#1
	move.l	d0,2(sp)
	move.w	#32,(sp)	; super

.loop:

	move.l	($4ba).l,d1

.buzz:

	cmp.l	($4ba).l,d1
	beq	.buzz

	subi.w	#5,d2
	bpl	.loop

	trap	#1
	addq.l	#6,sp

	movem.l	(sp)+,d0-2/a0-1

	rts
