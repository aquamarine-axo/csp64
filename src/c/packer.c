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

void main() {
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

// don't forget to add the FNUM CONVERTER function here...

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
        
        if (blockBits > 0) { CONVERT_FNUM_BLOCK(bf, blockBits, notebase >> 7); }
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