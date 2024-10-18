; Include: DECIMAL
; Version: 0.4
; Date:    2024-10-05

	section	text

; Convert 32-bit unsigned integer to decimal number
;
;   d0   - 32-bit number
;   d1.w - decimal point
;
; Output
;
;   a0   - text buffer

decimal_unsigned:

	movem.l	d5-7,-(sp)

	lea	decimal_buffer+1,a1
	lea	decimal_scale,a2

	move.w	#9,d7

	move.w	#0,d5
	tst.b	d1
	beq	.each
	move.b	#10,d5
	sub.b	d1,d5

.each:

	clr.b	d4
	move.l	(a2)+,d6

.loop:

	cmp.l	d6,d0	
	bmi	.next
	sub.l	d6,d0
	addq.b	#1,d4
	bra	.loop

.next:

	btst	#8,d5
	bne	.store
	tst.b	d4
	beq	.store
	move.l	a1,a0
	ori.w	#$100,d5

.store

	add.b	#'0',d4
	move.b	d4,(a1)+

	tst.b	d5
	beq	.no_dot
	subq.b	#1,d5
	bne	.no_dot

	btst	#8,d5
	bne	.skip
	lea	-1(a1),a0
	ori.w	#$100,d5

.skip:

	move.b	#'.',(a1)+

.no_dot:

	subq.b	#1,d7
	bne	.each	

	btst	#8,d5
	bne	.last
	move.l	a1,a0

.last:

	add.b	#'0',d0
	move.b	d0,(a1)+
	clr.b	(a1)

	movem.l	(sp)+,d5-7

	rts

; Convert 32-bit signed integer to decimal number
;
;   d0   - 32-bit number
;   d1.w - decimal point
;
; Output
;
;   a0   - text buffer

decimal_signed:

	tst.l	d0
	bpl	decimal_unsigned
	neg.l	d0
	bsr	decimal_unsigned
	move.b	#'-',-(a0)
	neg.l	d0

	rts

	section	data

	even

decimal_scale:

	dc.l	1000000000,100000000,10000000,1000000
	dc.l	100000,10000,1000,100,10

	section	bss

decimal_buffer:

	ds.b	13

	section	text
