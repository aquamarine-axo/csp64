/* 
Copyright © 2023 nicco1690

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// I have heavily commented this file so that anyone who might want to make changes can easily understand my thought process when writing this code.

    *=$0801

// 10 SYS 2304 ($0900)
.byte $0C,$08,$0A,$00,$9E,$20,$32,$30,$36,$34,$00,$00,$00

    *=$0810
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
    bvc playnote // if overflow occurs, it's not a note-on (continue)

// TODO: add routines for all of the other commands here

    rts

playnote:
    // here's the deal:
    // $00 to $b4 are note-ons
    // $00 being C--5, $b3 being B-9
    // so we need to do `cmp $4b` to check if it's a null note on and `rts` if it is, do nothing.

// TODO: everything else!

    rts // playnote is not a subroutine so this still works

*=$0e00 // Pitch data follows
// TODO: un-hardcode this
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

*=$1000 // CSP data follows