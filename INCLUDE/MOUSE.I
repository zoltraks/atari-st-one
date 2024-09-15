; Include: MOUSE
; Version: 0.1
; Date:    2024-09-12

	section	text

mouse_show:

	movem.l	d2/a0-1,-(sp)
	dc.w	$a009
	movem.l	(sp)+,d2/a0-1

	rts

mouse_hide:

	movem.l	d2/a0-2,-(sp)
	dc.w	$a00a
	movem.l	(sp)+,d2/a0-2

	rts
