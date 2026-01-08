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
