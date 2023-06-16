/* CSP64 packer program -- nicco1690 and contributors, 2023 */
/* see the LICENSE file in the root of the source code for license information. */

#include <stdint>
#include <stdio>

void main() {
    // TODO: take this values from the module and pass them in, instead of hard-coding it
    char linearPitch=2;
    int  tuning=440;
    char oldArpStrategy=0;
    char pitchMacroIsLinear=0;
}

// the following is a reimplementation of Furnace's tuning formula.
// if they look similar, it's because I need this to be exactly compatible with Furnace's tuning.
unsigned short calcFreqBase(double region, double divider, int note, bool period) {
    if (linearPitch == 2) { return (note << 7); } // full linear pitch

    double basease = (period? // if there is a period, do x. else do y. this is the worst C syntax I have ever seen
        (tuning * 0.0625):
        tuning * pow(2.0, (float)(nbase + 384)/(128 * 12)));

    return (period?
        (clock / base) / divider:
        base * (divider / clock);)
}

unsigned short calcFreq(int base, int pitch, int arp, bool arpIsFixed, bool period, int octave, int pitch2, double clock, double divider, int blockBits) {
    if (song.linearPitch==2) {
        int notebase = base + pitch + pitch2;
        if (!oldArpStrategy) {
            if (arpFixed) { notebase = (arp << 7) + pitch + pitch2; }
            else          { notebase += arp << 7; }
        }
        double freqBase = (period?
            (tuning * 0.0625):
            tuning) * pow(2.0, (float)(nbase + 384)/(128 * 12));
        
        int bf = period?
            round((clock / freqBase) / divider):
            round(freqBase * (divider / clock));
        
        if (blockBits > 0) { CONVERT_FNUM_BLOCK(bf, blockBits, noteBase >> 7); }
        else { return bf; }
    }

    if (linearPitch == 1) { // preferable this should be unsupported...
        int linearPitchHelper = (1024 + (globalPitch << 6) - (globalPitch < 0? globalPitch - 6:0));
        if (linearPitchHelper < 1) { linearPitchHelper = 1}; // division by zero workaround
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