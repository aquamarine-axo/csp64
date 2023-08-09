# Building CSP64

Currently, building is only possible on Windows due to the [build.bat](build.bat) file. This should change soon, however, as I will probably make a Unix version in the near future.

## If on Windows

1. Make sure that [Kick Assembler](http://www.theweb.dk/KickAssembler/Main.html) is installed in the right directory.
    - This directory should be a folder named "KickAss" in the folder below the folder that hosts the CSP64 source code.
    - For example, this could be `D:\src\KickAss`, while the source code is at `D:\src\csp64`.
2. Open your favourite command line application (Command Prompt, Powershell)
3. Navigate to the directory where the `build.bat` file is, and run it.

## If on MacOS, Unix, or Linux

~~TODO. a script for this will be made soon.~~ a script has been made!

1. Make sure that [Kick Assembler](http://www.theweb.dk/KickAssembler/Main.html) is installed in the right directory.
    - This directory should be a folder named "KickAss" in the folder below the folder that hosts the CSP64 source code.
    - For example, this could be `D:\src\KickAss`, while the source code is at `D:\src\csp64`.
2. Open your terminal of choice
3. Make sure that build.sh is executable by doing `chmod +x build.sh`
4. Do `./build.sh` to run the build script. (no I don't want to deal with makefiles)
