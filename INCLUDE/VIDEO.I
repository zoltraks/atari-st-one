; Include: VIDEO
; Version: 0.1
; Date:    2024-09-13

	section	text

video_check:
	
	move.w	#4,-(sp)	; getrez
	trap	#14
	addq.l	#2,sp

	beq	.mode_st_low
	cmpi.b	#1,d0
	beq	.mode_st_med
	cmpi.b	#2,d0
	beq	.mode_st_high
	cmpi.b	#3,d0
	beq	.mode_tt_med
	cmpi.b	#4,d0
	beq	.mode_tt_high

.end:

	move	video_width,d0
	lsr.w	#3,d0
	move.w	d0,video_columns
	move	video_height,d0
	lsr.w	#4,d0
	move.w	d0,video_rows
	move.w	video_width,d0
	swap	d0
	move.w	video_height,d0
	
	rts

.mode_st_low:

	move.w	#320,video_width
	move.w	#200,video_height
	move.w	#4,video_depth

	bra	.end

.mode_st_med:

	move.w	#640,video_width
	move.w	#200,video_height
	move.w	#2,video_depth

	bra	.end

.mode_st_high:

	move.w	#640,video_width
	move.w	#400,video_height
	move.w	#1,video_depth

	bra	.end

.mode_tt_med:

	move.w	#640,video_width
	move.w	#480,video_height
	move.w	#8,video_depth

	bra	.end

.mode_tt_high:

	move.w	#1280,video_width
	move.w	#960,video_height
	move.w	#1,video_depth

	bra	.end

	section	bss

	even

video_width:

	ds.w	1

video_height:

	ds.w	1

video_depth:

	ds.w	1

video_columns:

	ds.w	1

video_rows:

	ds.w	1

	section	text
