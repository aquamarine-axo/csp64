#!/bin/bash
# Copyright © 2023 nicco1690

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# ---

# csp64 ROM builder bashfile
# nicco1690, 2023

if [ ! -f "../kickass/KickAss.jar" ]; then
    echo -e "\033[38;5;196mhelloKick Assembler was not located!"
    echo -e "\033[38;5;163mhelloPlease place it in a folder named 'kickass' that is one layer below the source code for csp64. The Kick Assembler JAR should be here: '../kickass/KickAss.jar"
    exit 1 
fi
if [ -f "src/asm/main.prg" ]; then
    cd src/asm/
    rm main.prg
    echo -e "main.prg was already built... deleting and replacing."
    if [ -f "src/asm/main.sym" ]; then
        del main.sym
        echo -e "main.sym was already built... deleting and replacing."
    fi
    cd ../../
fi

cd ../kickass
java -jar KickAss.jar ../csp64/src/asm/main.asm

cd ../csp64
if [ ! -f "main.prg" ]; then
    echo -e "Errors were generated duing building. But I don't know why KickAss won't show me any output..."
else
    echo -e "Build files have been generated in '/src/asm' (this is a temporary location, will be changed in the future.)"
fi 
