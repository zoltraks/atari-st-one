; Program: CRC32
; Version: 0.3
; Date:    2024-10-05

EXIT_WAIT	equ	1

BUFFER_SIZE	equ	$400

	section	text

start:

 	movea.l	4(sp),a0	; tpa
	lea	stack,sp
	bsr	system_shrink
	bsr	command_parse
	bsr	mouse_hide
	bsr	console_clear
	bsr	mouse_show

	movea.l	command_line,a0
	tst.b	(a0)
	bne	.command_given

	lea	text_input_file,a0
	bsr	mouse_hide
	bsr	console_print
	bsr	console_input
	bsr	console_line
	bsr	mouse_show
	tst.b	d0
	beq	.done

	bsr	mouse_hide
	bsr	console_line
	bsr	mouse_show

	move.l	a0,d5
	bra	.file_open

.command_given:

	move.l	command_line,d5

.file_open:

	move.w	#1,-(sp)		; read mode
	subq.l	#4,sp
	move.l	d5,(sp)
	move.w	#$3d,-(sp)		; open
	trap	#1
	addq.l	#8,sp
	tst.w	d0
	bmi	.error_open
	
	move.w	d0,file_handle

	bsr	crc32_init

.read_loop:

	move.l	#file_buffer,-(sp)
	move.l	#BUFFER_SIZE,-(sp)
	move.w	file_handle,-(sp)
	move.w	#$3f,-(sp)		; read	
	trap	#1
	lea	12(sp),sp

	tst.l	d0
	bmi	.error_read	
	beq	.read_end

	add.l	d0,file_count
	lea	file_buffer,a0
	bsr	crc32_block
	cmpi.l	#BUFFER_SIZE,d0
	beq	.read_loop

.read_end:

	move.w	file_handle,-(sp)
	move.w	#$3e,-(sp)		; close
	trap	#1
	addq.l	#4,sp

	bsr	crc32_result
	lea	text_result,a0
	moveq.b	#4,d1
	bsr	hex_value
	bsr	console_print
	bsr	console_line

	bsr	crc32_free

	bra	.done

.error_open:

	bsr	error_gemdos
	tst.b	(a0)
	bne	*+8
	bsr	.error_other
	bsr	console_print
	bsr	console_line
	bra	.done

.error_read:

	bsr	error_gemdos
	tst.b	(a0)
	bne	*+8
	bsr	.error_other
	bsr	console_print
	bsr	console_line

	move.w	file_handle,-(sp)
	move.w	#$3e,-(sp)		; close
	trap	#1
	addq.l	#4,sp

	bmi	.error_close
	bra	.done

.error_close:

	bsr	error_gemdos
	tst.b	(a0)
	bne	*+8
	bsr	.error_other
	bra	.done

.error_other:

	lea	text_error,a0
	bsr	console_print
	bra	console_line

.done:

	IFD	EXIT_WAIT
	IFNE	EXIT_WAIT

	bsr	mouse_hide
	bsr	console_line
	lea	text_press_exit,a0
	bsr	console_print
	bsr	mouse_show

	bsr	wait_key

	ENDC
	ENDC

	clr.w	d0
	bra	system_exit

wait_key:

	bsr	console_has_key
	tst.w	d0
	bne	console_key
	bsr	system_vbl
	bra	wait_key	

	section	bss

	ds.b	$100

stack:

	ds.l	1

file_handle:

	ds.w	1

file_buffer:

	ds.b	BUFFER_SIZE

file_count:

	ds.l	1

text_result:

	ds.w	10	

	section	data

text_input_file:

	dc.b	'File to calculate CRC32: ',0

text_error:

	dc.b	'Error',0

text_press_exit:

	dc.b	'Press any key to exit...',0

text_space:

	dc.b	' ',0

	section	text

	include	'CRC32.I'

	include	'RUNTIME.I'

