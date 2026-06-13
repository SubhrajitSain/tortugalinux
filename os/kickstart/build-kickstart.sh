#!/bin/bash
sudo setenforce 0
mkdir -p build
ksflatten -c ./turtlinux.ks -o ./build/flat-turtlinux.ks
cd build
rm -rf ./iso_out
sudo livecd-creator \
    --config=flat-turtlinux.ks \
    --fslabel=turtlinux-live \
    --cache=./cache/live
sudo setenforce