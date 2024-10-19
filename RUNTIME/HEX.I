; Include: HEX
; Version: 0.2
; Date:    2024-09-16
; Author:  ZoltarX/NG

	section	text

; Convert value to hexadecimal number
;
;   d0   - value
;   d1   - size in bytes (1-4)
;
; Output
;
;   a0   - text buffer

hex_value:

	movem.l	d0-2,-(sp)

	lea	hex_buffer+9,a0
	clr.b	-(a0)
	
.loop:

	move.b	d0,d2

	andi.b	#15,d2
	addi.b	#'0',d2
	cmp.b	#':',d2
	bmi	.next_lo
	addi.b	#'A'-':',d2

.next_lo:

	move.b	d2,-(a0)
	move.b	d0,d2
	lsr.b	#4,d2
	andi.b	#15,d2
	addi.b	#'0',d2
	cmp.b	#':',d2
	bmi	.next_hi
	addi.b	#'A'-':',d2

.next_hi:

	move.b	d2,-(a0)

	subi.b	#1,d1
	beq	.done
	lsr.l	#8,d0
	bra	.loop	

.done:

	movem.l	(sp)+,d0-2

	rts

; Parse hexadecimal number
;
;   a0   - text buffer
;
; Output
;
;   d0   - parsed value

hex_parse:

	move.w	d1,-(sp)
	move.w	d2,-(sp)

	clr.l	d0
	move.w	#7,d2

.loop:

	move.b	(a0)+,d1
	beq	.zero
	cmp.b	#'0',d1
	bmi	.loop
	cmp.b	#'9'+1,d1
	bmi	.digit
	cmp.b	#'A',d1
	bmi	.loop
	cmp.b	#'F'+1,d1
	bmi	.upper
	cmp.b	#'a',d1
	bmi	.loop
	cmp.b	#'f'+1,d1
	bpl	.loop

	lsl.l	#4,d0
	subi.b	#'a'-10,d1
	add.b	d1,d0
	bra	.next

.digit:

	lsl.l	#4,d0
	subi.b	#'0',d1
	add.b	d1,d0
	bra	.next

.upper:

	lsl.l	#4,d0
	subi.b	#'A'-10,d1
	add.b	d1,d0
	
.next:
	
	dbra	d2,.loop

.zero:
	
	move.w	(sp)+,d2
	move.w	(sp)+,d1

	rts

	section bss

hex_buffer:

	ds.b	9

	section text
