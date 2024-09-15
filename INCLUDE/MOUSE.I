; Include: MOUSE
; Version: 0.1
; Date:    2024-09-12

	section	text

mouse_show:

	dc.w	$a009

	rts

mouse_hide:

	dc.w	$a00a

	rts
