; Program: FREEMEM
; Version: 0.2
; Date:    2024-09-15
; Author:  ZoltarX/NG

	section	text

start:

	move.l	4(sp),a5

	move.l	$c(a5),d0	; text size
	add.l	$14(a5),d0	; data size
	add.l	$1c(a5),d0	; bss size
	add.l	#$100,d0	; stack size
	move.l	d0,value_program_size

	move.l	#stack,sp

main:

	bsr	system_vbl
	bsr	mouse_hide
	bsr	console_clear
	bsr	console_line
	lea	text_free_start,a0
	bsr	console_print

	move.l	#-1,-(sp)
	move.w	#$48,-(sp)	; malloc
	trap	#1
	addq.l	#6,sp
	move.l	d0,value_memory_free

	clr.w	d1
	bsr	decimal_unsigned
	bsr	console_print
	bsr	console_line

	lea	text_program_size,a0
	bsr	console_print
	move.l	value_program_size,d0
	clr.w	d1
	bsr	decimal_unsigned
	bsr	console_print
	bsr	console_line

	move.l	a5,a0
	move.l	#$100,d0
	bsr	system_shrink

	lea	text_free_shrink,a0
	bsr	console_print
	
	move.l	#-1,-(sp)
	move.w	#$48,-(sp)	; malloc
	trap	#1
	addq.l	#6,sp
	move.l	d0,value_memory_free

	clr.w	d1
	bsr	decimal_unsigned
	bsr	console_print
	bsr	console_line 

	bsr	console_line
	lea	text_press,a0
	bsr	console_print
	bsr	mouse_show

	bsr	console_get
	clr.w	d0
	bra	system_exit

	section	bss

	ds.b	$100

stack:

	ds.l	1

	section	data

text_free_start:

	dc.b	'Free memory at startup: ',0

text_program_size:

	dc.b	'Program size in memory: ',0

text_free_shrink:

	dc.b	'Available after shrink: ',0

text_press:

	dc.b	'Press any key to exit program...',0

	section bss

value_memory_free:

	ds.l	1

value_program_size:

	ds.l	1

	section	text

	include	'CONSOLE.I'
	include	'DECIMAL.I'
	include	'SYSTEM.I'
	include	'MOUSE.I'
