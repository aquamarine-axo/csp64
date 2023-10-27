/* 
Copyright © 2023 nicco1690

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "../defines/hardware.asm"
#import "../defines/kernel.asm"
#import "../defines/csp.asm"

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
    sta sid_base_addr,x
    inx

    tya
    cmp #$00 // if (a != 0) then goto resetsidloop
    bne resetsidloop

    rts // otherwise, exit subroutine

startloop:
    lda c64_rastr_lin // get rasterline
    cmp #$1f
    bne startloop // A is no longer needed

    inc c64_bdr_color // border colour
    jsr sidtick
    dec c64_bdr_color // border colour pt2

sidtick:
    ldx #$00 // data offset
    lda $1000,x // csp data

    // determine if the current command is a note-on command
    adc #$4b
    bvc note_on // if overflow occurs, it's not a note-on (continue)

// TODO: add routines for all of the other commands here
    rts

note_on:
    // we need to do `cmp $4b` to check if it's a null note on and note-on but don't change the frequency
    // TODO: IMPLEMENT INSTRUMENTS!!

    cpx #$4b
    beq [note_on+3] // << this number represents the address of the code that follows loading the note frequency. this is for null note ons.
                 
    jsr get_note_fq // we now have X and Y as the frequency
    jsr set_note_fq // frequency set!!!!

    lda %10000000 // voice on, no waveform

    rts // playnote is not a subroutine so this still works

get_note_fq: // X is passed in as the note to use
    txa
    asl // A is multiplied by two, carry = bit that won't fit
    tax // value looks like this: %cxxxxxxxx (c=carry, x=x reg)
    
    ldy $0e00,x // frequency low byte
    lda $0e01,x // frequency high byte
    tax

    bcc [get_note_fq + 14] // inc this value when I add more
    rts
    // only get here if the value is >=256
    ldy $0f00,x // lsb
    lda $0f01,x // msb
    tax

    rts

set_note_fq: // y = frequency low byte, x = frequency high byte
    sty c64_vo1_freql
    stx c64_vo1_freqh
    rts

pre_note:
    /* Here is the chart that I used to understand pre_note:
        00 | C-4
        01 | ...
        02 | C-4
        translates into:
        row 0 : tick 0: NOTE_ON C-4
                tick 1: ...
                tick 2: ...
        row 1 : tick 3: PRE_NOTE    $BC01+(value of $BC00) = 2
                tick 4: ...         $BC01+(value of $BC00) = 1
                tick 5: ...         $BC01+(value of $BC00) = 0 - HARD RESET and GATE/TEST
        row 2:  tick 6: NOTE_ON C-4
                ...
    */
    rts

*=$0e00 "Dummy pitch table"

    // the deal part two:
    // this table is populated by the packer program. as such, it should be left blank.
    //    c       c#      d       d#      e       f       f#      g       g#      a       a#      b
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // -5  00-0b
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // -4  0c-17
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // -3  18-23
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // -2  24-2f
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // -1  30-3b
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 0   3c-47
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 1   48-53
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 2   54-5f
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 3   60-6b
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 4   6c-77
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 5   78-83
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 6   84-8f
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 7   90-9b
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 8   9c-a7
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 9   a8-b3

*=$1000 "Command Stream data"
