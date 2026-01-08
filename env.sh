: ${PICO_BOARD:=pico2}
: ${BUILD_DIR:=build2}     # 2 for pico2

: ${PICOTOOL_FETCH_FROM_GIT_PATH:=$HOME/picotool}
: ${PICO_SDK_PATH:=$HOME/projects/rpi-pico/pico-sdk}

export PICO_BOARD
export BUILD_DIR
export PICOTOOL_FETCH_FROM_GIT_PATH
export PICO_SDK_PATH

echo "Build Environment"
echo "==="
echo "Board: $PICO_BOARD"
echo "Build dir: $BUILD_DIR"
echo "Pico tool directory: $PICOTOOL_FETCH_FROM_GIT_PATH"
echo "Pico sdk path:  $PICO_SDK_PATH"
echo "==="
echo

