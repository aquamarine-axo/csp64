@echo off
rem Copyright © 2023 nicco1690
 
rem Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
rem The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

rem THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

rem csp64 ROM builder batchfile
rem nicco1690, 2023

if not exist "../kickass/kickass.jar" (
    echo Kick Assembler was not located! 
    echo Please place it in a folder named "kickass" that is 1 layer below the source code for csp64. The Kick Assembler JAR should should be here: '../kickass/kickass.jar'
    exit /b 1
) 
if exist "main.prg" (
    del main.prg
    echo main.prg was already built... deleting and replacing.
    if exist "main.sym" (
        del main.sym
        echo main.sym was already built... deleting and replacing.
    )
)

cd ../kickass
kickass.jar ../csp64/main.asm
cd ../csp64

if not exist "main.prg" (
    echo Errors were generated during building. But I don't know why KickAss won't show me any output...
)
