/* 
Copyright © 2023 nicco1690

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// CSP64 hardware register defines
// nicco1690 and contributors, 2023

// ---- SID ----
.const c64_vo1_freqh = $d400
.const c64_vo1_freql = $d401
.const c64_vo1_pulwh = $d402
.const c64_vo1_pulwl = $d403
.const c64_vo1_cntrl = $d404
.const c64_vo1_da    = $d405
.const c64_vo1_rs    = $d406
.const c64_vo2_freqh = $d407
.const c64_vo2_freql = $d408
.const c64_vo2_pulwh = $d409
.const c64_vo2_pulwl = $d40a
.const c64_vo2_cntrl = $d40b
.const c64_vo2_da    = $d40c
.const c64_vo2_rs    = $d40d
.const c64_vo3_freqh = $d40e
.const c64_vo3_freql = $d40f
.const c64_vo3_pulwh = $d410
.const c64_vo3_pulwl = $d411
.const c64_vo3_cntrl = $d412
.const c64_vo3_da    = $d413
.const c64_vo3_rs    = $d414
.const c64_flt_cutfh = $d415 // 00000111 // 1 = used // 0 = unused
.const c64_flt_cutfl = $d416 // 11111111
.const c64_flt_cntrl = $d417
.const c64_vol_n_flt = $d418
// paddle x and paddle y go here
.const c64_vo3_outpt = $d41b
.const c64_vo3_adsro = $d41c

.const c64_bdr_color = $d020
.const c64_bgr_color = $d021
.const c64_bg2_color = $d022
.const c64_bg3_color = $d023
