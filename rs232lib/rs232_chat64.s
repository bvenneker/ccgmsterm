; CCGMS Terminal
;
; Copyright (c) 2016,2022, Craig Smith, alwyz, Michael Steil. All rights reserved.
; This project is licensed under the BSD 3-Clause License.
;

.include "rs232_kernal.inc"
.include "rs232.inc"		; for MODEM_TYPE_*
.import ribuf			; external
.import rs232_rti

; function table for dispatcher
.export chat64_funcs

; Chat64 registers
cartridge	= $de00		; will be runtime-patched to $DE00/$DF00/$D700


.segment "RS232"
  
;----------------------------------------------------------------------
chat64_funcs:
	.word chat64_setup
	.word chat64_enable
	.word chat64_disable
	.word chat64_getxfer
	.word chat64_putxfer
	.word chat64_dropdtr

;----------------------------------------------------------------------
; new NMI handler
chat64_NMI:
    ; your code here ;)
    jmp rs232_rti ; 

;----------------------------------------------------------------------
chat64_setup:
  inc $d020
  jmp chat64_setup
  ; setup NMI
  lda #<chat64_NMI
  ldx #>chat64_NMI
  sta $0318  
  stx $0319

	
  ;lda #126
  ;sta cartridge
  rts
  
;----------------------------------------------------------------------
chat64_enable:

	rts

;----------------------------------------------------------------------
chat64_disable:

	rts
	

;----------------------------------------------------------------------
chat64_getxfer:
	
  rts
  
;----------------------------------------------------------------------
chat64_putxfer:

	rts

;----------------------------------------------------------------------
chat64_dropdtr:

	rts




