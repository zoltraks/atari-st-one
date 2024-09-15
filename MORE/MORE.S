; Program: MORE
; Version: 1.0
; Date:    2024-09-13

;DEBUG	equ	1

	section	text

start:

 	movea.l	4(sp),a0	; tpa
       	lea	stack,sp
	movea.l	a0,a5

	bsr	system_shrink
	bsr	command_parse
	bsr	video_check
	bsr	mouse_hide
	bsr	console_clear
	
	movea.l	command_line,a0
	tst.b	(a0)
	beq	.no_file

	bsr	skip_empty		; trim command line arguments

	IFD	DEBUG
	IFNE	DEBUG

	lea	text_command_line,a0
	bsr	console_print
	movea.l	a5,a0
	lea	$81(a0),a0
	bsr	console_print
	bsr	console_line

	ENDC
	ENDC

	move.w	#1,-(sp)		; read
	subq.l	#4,sp
	move.l	command_line,(sp)
	move.w	#$3d,-(sp)		; open
	trap	#1
	addq.l	#8,sp
	tst.w	d0
	bmi	.error_open
	
	move.w	d0,file_handle

		

	IFD	DEBUG
	IFNE	DEBUG

	ENDC
	ENDC

	bsr	.end_of_file

.error_open:

	bsr	error_gemdos
	tst.b	(a0)
	bne	.error_open_text

	bsr	goto_bottom
	lea	text_error,a0
	bsr	console_print
	bra	.error_open_done

.error_open_text:

	movea.l	a0,a3
	bsr	goto_bottom
	lea	text_error,a0
	bsr	console_print
	lea	text_space,a0
	bsr	console_print
	movea.l	a3,a0
	bsr	console_print
	lea	text_space,a0
	bsr	console_print
	movea.l	command_line,a0
	bsr	console_print

.error_open_done:

	bsr	mouse_show
	bsr	cursor_disable
	bsr	console_key
	bra	.exit
	
.done:

	IFD	DEBUG
	IFNE	DEBUG

	bsr	console_line
	lea	text_press,a0
	bsr	console_print

	ENDC
	ENDC

	;bsr	console_line
	;lea	text_lorem,a0
	;bsr	console_print
	;bsr	console_line

	bsr	mouse_show

	bsr	console_key

.exit:

	clr.w	d0
	bra	system_exit

.no_file:

	bsr	goto_bottom
	lea	text_no_file,a0
	bsr	console_print

	bra	.done

.end_of_file:

	bsr	goto_bottom
	lea	text_end_of_file,a0
	bsr	console_print
	bsr	cursor_disable
	bsr	console_key
	bra	.done

skip_empty:

	move.b	(a0),d0
	cmpi.b	#' ',d0
	beq	.skip
	cmpi.b	#9,d0
	beq	.skip

	rts

.skip:

	addq.l	#1,a0
	bra.s	skip_empty	

goto_bottom:

	lea	text_goto,a0
	move.w	video_rows,d0
	addi.w	#32,d0
	move.b	d0,2(a0)
	move.b	#32,3(a0)

	bsr	console_print

	rts

	section	bss

	ds.b	$100

stack:

	ds.l	1

file_handle:

	ds.w	1

	section	data

text_ok:

	dc.b	'OK',13,10,0

text_read_file:

	dc.b	'Reading file: ',0

text_command_line:

	dc.b	'Command line: ',0

text_no_file:

	dc.b	'-No file-',0

text_error:

	dc.b	'-Error-',0

text_error_prefix:

	dc.b	'-Error: ',0

text_error_suffix:

	dc.b	'-',0

text_hello:

	dc.b	'Hello, ATARI.',0

text_goto:

	dc.b	27,'Y'

text_goto_y:

	dc.b	' '

text_goto_x:

	dc.b	' '
	dc.b	0

text_direct:

	dc.b	'A','a',9,'B','b',8,'C','c',1,'D','d',2
	dc.b	13,10
	dc.b	0

text_end_of_file:

	dc.b	'-End of file-',0

text_press:

	dc.b	'Press any key to exit...',0

text_space:

	dc.b	' ',0

	section	text

	include	'RUNTIME.I'
