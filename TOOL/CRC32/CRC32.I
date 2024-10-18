; Include: CRC32
; Version: 1.0
; Date:    2024-10-07
; Author:  ZoltarX/NG

	section	text

; Initialize CRC32 checksum

crc32_init:

	clr.w	crc32_done
	move.l	#-1,crc32_value
	tst.l	crc32_table
	beq	*+6

	rts

	movem.l	d0-5/a0-2,-(sp)

	move.l	#256*4,-(sp)
	move.w	#$48,-(sp)	; malloc
	trap	#1
	addq.l	#6,sp

	move.l	d0,crc32_table
	movea.l	d0,a0
	clr.l	d1
	move.l	crc32_polynominal,d5

.loop:

	move.l	d1,d2
	moveq	#8-1,d3

.eight:

	move.l	d2,d4
	lsr.l	#1,d2
	andi.l	#1,d4
	beq	.skip
	eor.l	d5,d2

.skip:

	dbf	d3,.eight

	move.l	d2,(a0)+

	addi.w	#1,d1
	cmpi.w	#256,d1
	bne	.loop

	movem.l	(sp)+,d0-5/a0-2

	rts

; Feed checksum with block
;
;   a0   - input buffer
;   d0   - number of bytes

crc32_block:

	tst.l	d0
	bne	*+6

	rts

	movem.l	d0-2/a0-1,-(sp)

	subi.l	#1,d0
	move.l	crc32_value,d2

.loop:

	clr.l	d1
	move.b	(a0)+,d1
	eor.b	d2,d1
	asl.w	#2,d1
	add.l	crc32_table,d1
	movea.l	d1,a1
	lsr.l	#8,d2
	move.l	(a1),d1
	eor.l	d1,d2
	dbf	d0,.loop

	move.l	d2,crc32_value

	movem.l	(sp)+,d0-2/a0-1

	rts

; Finish CRC32 calculation and return result
;
; Output:
;
;   d0   - CRC32 

crc32_result:

	move.l	crc32_value,d0
	tst.w	crc32_done
	beq	*+6

	rts
 
	addi.w	#1,crc32_done
	eori.l	#-1,d0
	move.l	d0,crc32_value

	rts

; Free previously allocated resources

crc32_free:

	tst.l	crc32_table
	bne	*+6

	rts

	movem.l	d0/a0,-(sp)

	move.l	crc32_table,-(sp)
	move.w	#$49,-(sp)	; mfree
	trap	#1
	addq.l	#6,sp

	clr.l	crc32_table

	movem.l	(sp)+,d0/a0

	rts	

	section	bss

crc32_value:

	ds.l	1

crc32_done:

	ds.w	1

	section	data

	even

crc32_polynominal:

	dc.l	$edb88320

crc32_table:

	dc.l	0

	section text
