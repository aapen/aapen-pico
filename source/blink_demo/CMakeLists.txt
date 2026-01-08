cmake_minimum_required(VERSION 3.14)

# Include app source code file(s)
add_executable(blink_demo
               ${BLINK_SRC_DIRECTORY}/main.S
               ${COMMON_SRC_DIRECTORY}/sdk_inlines.c
)

# Link to built libraries
target_link_libraries(blink_demo LINK_PUBLIC
                      pico_stdlib
                      hardware_gpio
)

# Enable/disable STDIO via USB and UART
pico_enable_stdio_usb(blink_demo 1)
pico_enable_stdio_uart(blink_demo 1)

# Enable extra build products
pico_add_extra_outputs(blink_demo)
