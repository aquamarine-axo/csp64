/* 
Copyright © 2023 nicco1690

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// I have heavily commented this file so that anyone who might want to make changes can easily understand my thought process when writing this code.


// TODO: Move these into csp.asm
.const csp_curchan    = $bc00
.const csp_chn1_delay = $bc01
.const csp_chn2_delay = $bc02
.const csp_chn3_delay = $bc03

.import source "../defines/c64_hardware.asm"
//.import source "../defines/c64_kernel.asm"
//.import source "../defines/csp.asm"

    *=$0801 "BASIC Loader"
// 10 SYS 2304 ($0900)
.byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00

    *=$0810 "Program"
    jsr resetsid
    jsr startloop

resetsid:
    lda #$00 // store this in all sid registers
    tax      // offset
    ldy #$17 // loop amount

resetsidloop:
    lda #$00 // reset the value of a
    sta $d400,x
    inx

    tya
    cmp #$00 // if (a != 0) then goto resetsidloop
    bne resetsidloop

    rts // otherwise, exit subroutine

startloop:
    lda $d012 // get rasterline
    cmp #$1f
    bne startloop // A is no longer 

    inc $d020 // border colour
    jsr sidtick
    dec $d020 // border colour pt2

sidtick:
    ldx #$00 // data offset
    lda $1000,x // csp data

    // determine if the current command is a note-on command
    adc #$4b
    bvc note_on // if overflow occurs, it's not a note-on (continue)

// TODO: add routines for all of the other commands here
    rts

note_on:
    // here's the deal:
    // $00 to $b4 are note-ons
    // $00 being C--5, $b3 being B-9
    // so we need to do `cmp $4b` to check if it's a null note on and `rts` if it is, do nothing.

    // TODO: IMPLEMENT INSTRUMENTS!!

    cpx #$4b
    beq [note_on+69] // TODO: change the number when I'm done coding the routine
            //   ^^     this number represents the address of the code that follows loading the note                 
    stx c64_vo1_freqh // TODO: this is a temporary address. I need to process it and get the real frequency

    lda %10000000 // voice on, no waveform

    rts // playnote is not a subroutine so this still works

pre_note:
    // TODO

*=$0e00 "Dummy pitch table"

    // the deal part two:
    // this table is populated by the packer program. as such, it should be left blank.
    //    c     c#    d     d#    e     f     f#    g     g#    a     a#    b
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // -5
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // -4
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // -3
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // -2
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // -1
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // -0
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 1
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 2
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 3
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 4
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 5
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 6
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 7
    .byte $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000 // 8

*=$1000 "Command Stream data"