# AAPen Forth for the Raspberry Pi Pico2

This is an experiment in porting aapenforth to the
raspberry pi pico2.

## Building

You will need a full pi pico gcc build enviornment.
See `env.sh` for the environment variables/directories you will need.

To set up the build directory, simply run the `setup.sh` script:

```
$ ./setup.sh
```

Once you've done that you can cd to the `build2` directory
and run `make`.

### Running on hardware (the hard way)

The simplest way to get aapen running on a pico (a pico2!
aka the rp2350) is to connect the pico to your computer
via USB while *holding down the button on the board*
while you do the connecting.

This will make the pico show up as a USB drive. Simply
copy the firmware--the file that ends in `.uf2` to
the new drive. This should cause the board to reboot,
the drive to disappear and the firmware to run.

### Debugging on hardware

For development you are going to need an interactive
in-chip solution. This you can do by buying a pico
[debug probe.](https://www.raspberrypi.com/documentation/microcontrollers/debug-probe.html#updating-the-firmware-on-the-debug-probe)

Alternatively you can fashion a debugprobe from yourself from a second pico as documented in
Appendix A of [the Pico Getting started guide.](https://pip-assets.raspberrypi.com/categories/610-raspberry-pi-pico/documents/RP-008276-DS-1-getting-started-with-pico.pd)
Note that the debugprobe firmware for that second pico is [here.](https://github.com/raspberrypi/debugprobe/releases)

You will also need a custom version of `openocd` to do the in-chip debugging, which you can
build yourself. This is what it looks like using a PI5 as a development machine:

```
git clone https://github.com/raspberrypi/openocd.git --branch picoprobe --depth=1 --no-single-branch
cd openocd/
./bootstrap 
./configure --enable-picoprobe
make -j4 --no
```

Once that is built you can start up the openocd that you just built and connect to the 
pico:

```
src/openocd -s tcl -f interface/cmsis-dap.cfg -f target/rp2350.cfg -c "adapter speed 5000"
```

This should open a remote gdb port on 3333.

In a different window start gdb:

```
gdb aapen_pico.elf --ex "target extended-remote :3333"
```

And you are off and debugging.

## Repo Structure

Code in this repo uses the `.syntax unified` directive.

```
/pico-asm
|
|___/source
|   |___/blink_demo        // Flash the Pico LED.
|   |   |___CMakeLists.txt  // App CMake config file
|   |   |___main.S          // App assembly source
|   |   
|   |___/aapen_forth
|   |   |___CMakeLists.txt  // App CMake config file
|   |   |___jonesforth.s    // Modified copy of the original jonesforth.s
|   |   |___main.S          // App assembly source
|   |
|   |___/common             // Common source files from Tony Smit.
|       |___sdk_inlines.c   // Wrappers for SDK inline C functions
|
|___CMakeLists.txt          // Top-level project CMake config file
|___pico_sdk_import.cmake   // Raspberry Pi Pico SDK CMake import script
|___deploy.sh               // Build-and-deploy shell script
|
|___README.md
|___LICENSE.md
```



### Credits

The `source/aapen_forth/joinesforth.s` is derived from 
[here.](https://github.com/organix/pijFORTHos/blob/master/jonesforth.s)

We are grateful Tony Smith for the build scripts and directory structure.
See [this github project.](https://github.com/smittytone/pico-asm/tree/main)
The build code that we adopted is © 2022, Tony Smith, and is licensed 
under the terms of the [MIT Licence](./MIT_LICENSE.md)
