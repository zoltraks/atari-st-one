; Program: CMDLINE
; Version: 1.0
; Date:    2024-09-13

	section	text

start:

	move.l	4(sp),a5	; tpa

	lea	stack,sp

	bsr	mouse_hide

	bsr	console_clear

	tst.b	128(a5)		; cmdlin
	beq	.no_cmdlin

	lea	text_command_line,a0
	bsr	console_print
	move.l	a5,d0
	addi.l	#$81,d0
	move.l	d0,a0
	bsr	console_print
	bsr	console_line

.done:

	bsr	console_line
	lea	text_press,a0
	bsr	console_print
	bsr	mouse_show
	bsr	console_get

	clr.w	d0
	bra	system_exit

.no_cmdlin:

	lea	text_no_command_line,a0
	bsr	console_print
	bsr	console_line

	bra	.done

	section	bss

	ds.b	$100

stack:

	ds.l	1

	section	data

text_command_line:

	dc.b	'Command line: ',0

text_no_command_line:

	dc.b	'No command line',0

text_press:

	dc.b	'Press any key to exit...',0

	section	text

	include	'DECIMAL.I'

	include	'CONSOLE.I'

	include	'SYSTEM.I'

	include	'MOUSE.I'
 