; Include: STRING
; Version: 0.2
; Date:    2024-10-05

	section	text

; Copy one string to another
;
;   a0   - source string
;   a1   - destination string
;   d0   - limit number of characters
;
; Output
;
;   d1   - number of characters copied

string_copy:

	movem.l	d0/a0-1,-(sp)

	clr.l	d1
	tst.l	d0
	beq	.no_limit
	subi.w	#1,d0

.yes_limit:

	tst.b	(a0)
	beq	.terminate
	addq.w	#1,d1
	move.b	(a0)+,(a1)+
	dbf	d0,.yes_limit

.terminate:

	clr.b	(a1)

	movem.l	(sp)+,d0/a0-1

	rts

.no_limit:

	tst.b	(a0)
	beq	.terminate
	addq.w	#1,d1
	move.b	(a0)+,(a1)+
	bra	.no_limit

