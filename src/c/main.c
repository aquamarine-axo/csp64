/* CSP64 main program -- nicco1690 and contributors, 2023 */
/* see the LICENSE file in the root of the source code for license information. */

#define CSP_VERSION 1

#include <stdio.h>
#include <conio.h>
#include <string.h>
#include "pitch_formula.h"

int main(int argc, char *argv[]) {
    printf("CSP64 - (c) nicco1690 and contributors - version: dev%i", CSP_VERSION);
    if (((strcmp(argv[1],"-f")) != 0) || ((strcmp(argv[1],"--file")) != 0)) { // if no valid arguments are specified
        puts("usage: csp64 [arguments]\n\narguments:\n -f [--file] (/path/to/command/stream/file): open file for processing");
    } else if ((strcmp(argv[2],"")) != 0) {
        
    } else {
        FILE *file; 
        file = fopen(argv[2], r);
    }
}
