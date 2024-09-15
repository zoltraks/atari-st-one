; Include: VIDEO
; Version: 0.1
; Date:    2024-09-13

	section	text

; Call AES

video_call_aes:

	move.l	#video_aespb,d1
	move.w	#$c8,d0		; ?
	trap	#2

	rts

; Call VDI

video_call_vdi:

	move.l	#video_vdipb,d1
	moveq.l	#$73,d0		; ?
	trap	#2

	rts

	section	bss

	even

video_aespb:

	ds.l	$100

video_vdipb:

	ds.l	$100

	section	text
