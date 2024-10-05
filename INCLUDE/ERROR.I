; Include: ERROR
; Version: 1.0
; Date:    2024-09-15

	section	text

; Get error text for GEMDOS error code
;
;	d0	- GEMDOS error code
;
; Output
;
;	a0	- error text

error_gemdos:

	cmpi.b	#-33,d0
	beq	.file_not_found
	cmpi.b	#-34,d0
	beq	.path_not_found
	cmpi.b	#-46,d0
	beq	.drive_not_found
	cmpi.b	#-39,d0
	beq	.not_enough_memory
	lea	error_text_default,a0

	rts

.file_not_found:

	lea	error_text_file_not_found,a0

	rts

.path_not_found:

	lea	error_text_path_not_found,a0

	rts

.drive_not_found:

	lea	error_text_drive_not_found,a0

	rts

.not_enough_memory:

	lea	error_text_not_enough_memory,a0

	rts

	section	data

error_text_default:

	dc.b	0

error_text_file_not_found:

	dc.b	'File not found',0

error_text_path_not_found:

	dc.b	'Path not found',0

error_text_drive_not_found:

	dc.b	'Drive not found',0

error_text_not_enough_memory:

	dc.b	'Not enough memory',0

	section	text

