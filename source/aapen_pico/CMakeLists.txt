cmake_minimum_required(VERSION 3.14)

# Include app source code file(s)
add_executable(${APP_NAME}
               ${APP_SRC_DIRECTORY}/main.S
               ${APP_SRC_DIRECTORY}/jonesforth.s
               ${COMMON_SRC_DIRECTORY}/sdk_inlines.c
)

# Link to built libraries
target_link_libraries(${APP_NAME} LINK_PUBLIC
                      pico_stdlib
                      hardware_gpio
)

# Enable/disable STDIO via USB and UART
pico_enable_stdio_usb(${APP_NAME} 1)
pico_enable_stdio_uart(${APP_NAME} 1)

# Enable extra build products
pico_add_extra_outputs(${APP_NAME})
