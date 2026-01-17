; CCGMS Terminal
;
; Copyright (c) 2016,2022, Craig Smith, alwyz, Michael Steil. All rights reserved.
; This project is licensed under the BSD 3-Clause License.
;

.include "rs232_kernal.inc"
.include "rs232.inc"                         ; for MODEM_TYPE_*
.import ribuf                                      ; external
.import rs232_rti

; function table for dispatcher
.export chat64_funcs


; Chat64 registers
cartridge              = $de00                                ; will be runtime-patched to $DE00/$DF00/$D700

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
; On chat64 NMI is triggered when there is a new byte in the output buffer
; of the cartridge.
; Collect that byte from the cartridge and put them in the buffer
; tail   == head -> buffer is empty
; tail+1 == head -> buffer is full
chat64_NMI:
        pha
        txa
        pha
        tya
        pha
 
                         ; before we write.. check if buffer is full
        lda rtail        ; get head position
        clc              ; clear carry for addition
        adc #1           ; add 1 to head position
        cmp rhead        ; compare with tail
        beq bufferfull   ; if equal, the buffer is full. do not write!
 
        ldx rtail        ; load the tail position in x as index
        lda $DF00        ; load a byte from the cartridge
        sta ribuf,x      ; write the byte to the buffer, with x as index
        inc rtail        ; increase tail for next round
 
bufferfull:       
        pla
        tay
        pla
        tax
        pla
        jmp rs232_rti ;
 
;----------------------------------------------------------------------
chat64_setup:
 
  ; setup NMI
  lda #<chat64_NMI
  ldx #>chat64_NMI
  sta $0318 
  stx $0319
  lda #226
  sta $DE00
  rts
 
;----------------------------------------------------------------------
chat64_enable:
 
                rts
 
;----------------------------------------------------------------------
chat64_disable:
                rts
               
 
;----------------------------------------------------------------------
; Read a byte from the tail of the buffer
; tail position: rtail
; buffer: ribuf
; put the result in A
;----------------------------------------------------------------------
chat64_getxfer:
               
        ldx rhead       ; skip if head is equal to tail
        cpx rtail
        beq :+          ; skip (empty buffer, return with carry set)
        lda ribuf,x     ; read a byte from the tail end
        inx             ; increase head
        stx rhead       ; store tail
        clc             ; clear carry bit
        rts
:       sec             ; set carry
        rts
 
;----------------------------------------------------------------------
chat64_putxfer:
    sta $DE00
                rts
 
;----------------------------------------------------------------------
chat64_dropdtr:
   
                rts
