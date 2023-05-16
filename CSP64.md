# CSP64

Command Stream Player for the c64

CSP64 is (or will be...) the framework behind the C64 SID export found in Furnace in version 0.7.

At the moment, it does not do much. Right now, it's just the framework for the driver it will use but no actual SID playback has been done. 

## how it works

1. CSP64 starts with compilation of the script for editing and packing FCS (Furnace Command Stream) files.
    - It has not been made yet...
2. Then, the script is executed. It does the aforementioned packing of FCS files, but it also assembles the source code (it has to be modular for Furnace, coming later) to a PRG file, and the FCS file is inserted at `$1000`.
3. This `.prg` file is loaded and executed in your emulator (or real hardware) of choice. It plays the music, along with providing some visual feedback (but only in the `.prg`, not any other format).

## contributing

Pull requests, bug reports and feature requests are more than welcome! But, please keep in mind that:

- I do not have to implement or fix anything you say.
- Your PR's code must have a compatible license if it introduces an external dependancy. This also needs to apply to the dependency in question. 
    - You must also prove to me that adding the dependancy is worthwhile. I am trying to keep this project as micro as possible, in both size and speed.
- As with any project, please allow everyone to speak freely.

## building

Want to beta test? See [building.md](building.md) for details. **does not exist right now!**

## footer

- See the license: [LICENSE](LICENSE)
- Support Furnace: [https://github.com/tildearrow/furnace](https://github.com/tildearrow/furnace)
