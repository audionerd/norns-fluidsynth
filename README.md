# norns fluidsynth

simple script to start the fluidsynth soundfont player as a separate process.
uses alsa to connect a virtual midi device to fluidsynth.
then use the [passthrough](https://llllllll.co/t/passthrough-v2/49397) mod and norns can route MIDI from any device to that virtual midi device and on to fluidsynth. 

    keyboard -> norns -> passthrough -> virtual -> fluidsynth

the script also connects the fluidsynth audio outputs to norns via jack:

    fluidsynth:left -> crone:input_5
    fluidsynth:right -> crone:input_6

## install

fluidsynth is required. it can be built from source on norns:

    ssh we@norns.local
    cd /usr/local/src
    sudo su
    curl https://codeload.github.com/FluidSynth/fluidsynth/tar.gz/refs/tags/v2.3.1 -o fluidsynth-2.3.1.tar.gz
    tar -zxvf fluidsynth-2.3.1.tar.gz
    cd fluidsynth-2.3.1
    mkdir build
    cd build
    cmake ..
    make
    make install
    ldconfig

install passthrough via maiden REPL (or web ui)

    ;install https://github.com/nattog/passthrough

Enable passthrough via `SYSTEM > MODS`

Restart via `SYSTEM > RESTART`

Then setup a `virtual` device in `SYSTEM > DEVICES > MIDI` if you haven’t already.

To route from a MIDI device to fluidsynth, `SYSTEM > MODS > PASSTHROUGH`
- Active: Yes
- Target: virtual

## future

fluidsynth listens on port 9800, so norns could communicate with it to control volume, load user-selectable SF2s, run program changes, etc.
