#!/bin/sh

. ./env.sh


echo "Creating a build for the $PICO_BOARD in $BUILD_DIR."

rm -rf $BUILD_DIR

cmake -B $BUILD_DIR -DPICO_BOARD=$PICO_BOARD
