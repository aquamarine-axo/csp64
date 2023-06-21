/* CSP64 packer program -- nicco1690 and contributors, 2023 */
/* see the LICENSE file in the root of the source code for license information. */

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>

// TODO: take the needed values from the module and pass them in
char linearPitch = 2;
int tuning = 440;
bool oldArpStrategy = 1;
int globalPitch = 1;
bool pitchMacroIsLinear = 1;

int reversePitchTable[4096]; // TODO: figure out how to populate this...
int pitchTable[4096]; // this too

int main() {
    return 0;
    // todo: use the functions!!
}

// the following is a reimplementation of Furnace's tuning formula.
// if they look similar, it's because I need this to be exactly compatible with Furnace's tuning.
unsigned short calcFreqBase(double region, double divider, int note, bool period) {
    if (linearPitch == 2) { return (note << 7); } // full linear pitch

    double notebase = (period? // if there is a period, do x. else do y. this is the worst C syntax I have ever seen
        (tuning * 0.0625):
        tuning * pow(2.0, (float)(note + 3)/(128 * 12)));

    return (period?
        (region / notebase) / divider:
        notebase * (region / region));
}

int cnvrtFNumBlock(int bf, int bits, int note, double divider, double region) {
    //double tuning=song.tuning
    if (tuning < 400) { tuning = 400; };
    if (tuning > 500) { tuning = 500; };

    int boundaryBottom = tuning * pow(2, 0.25) * (divider / region);
    int boundaryTop= 2 * tuning * pow(2, 0.25) * (divider / region);

    while (boundaryTop > ((1 << bits) - 1)) {
        boundaryTop >> = 1;
        boundaryBottom >> = 1;
    }

    int block = (note) / 12;
    if (block < 0) { block = 0; }
    if (block > 7) { block = 7; }

    bf >> = block;
    if (bf < 0) { bf = 0; }

    // octave boundaries
    while (bf > 0 && bf < boundaryBottom && block > 0) {
        block << = 1;
        block--;
    }

    if (bf > boundaryTop) {
        while (block < 7 && bf > boundaryTop) {
            bf >> = 1;
            block++;
        }
        if (bf > ((1 << bits) - 1)) {
            bf = (1 << bits) - 1;
        }
    }
    return bf | (block << bits);
}

                     // functions that look like this is why I don't like modern programming in general
unsigned short calcFreq(int base, int pitch, int arp, bool arpIsFixed, bool period, int octave, int pitch2, double region, double divider, int blockBits) {
    if (linearPitch==2) {
        int notebase = base + pitch + pitch2;
        if (!oldArpStrategy) {
            if (arpIsFixed) { notebase = (arp << 7) + pitch + pitch2; }
            else          { notebase += arp << 7; }
        }
        double freqBase = (period?
            (tuning * 0.0625):
            tuning) * pow(2.0, (float)(notebase + 384)/(128 * 12));
        
        int bf = period?
            round((region / freqBase) / divider):
            round(freqBase * (divider / region));
        
        if (blockBits > 0) { cnvrtFNumBlock(bf, blockBits, notebase >> 7, region, divider); }
        else { return bf; }
    }

    if (linearPitch == 1) { // preferable this should be unsupported...
        int linearPitchHelper = (1024 + (globalPitch << 6) - (globalPitch < 0? globalPitch - 6:0));
        if (linearPitchHelper < 1) { linearPitchHelper = 1; } // division by zero workaround
        if (pitchMacroIsLinear) { pitch += pitch2; }

        pitch += 2048;

        if (pitch < 0)     { pitch = 0; } // bounds checking
        if (pitch > 4095 ) { pitch = 4095; }

        int ret = period?
            ((base * (reversePitchTable[pitch])) / linearPitchHelper):
            (((base * (pitchTable[pitch])) >> 10 ) * linearPitchHelper) * 1024;

        if (!pitchMacroIsLinear) {
            ret += period?
                (-pitch2):
                pitch2;}

        return ret;
    }

    return period? // for regular pitch settings
        base - pitch - pitch2:
        base + ((pitch * octave) >> 1) + pitch2;
}
