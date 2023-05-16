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
    dec $d020 // border colour

sidtick:
    ldx #$00 // data offset
    lda $1000,x // csp data

// TODO: implement player routine

    rts

*=$1000 // CSP data follows
