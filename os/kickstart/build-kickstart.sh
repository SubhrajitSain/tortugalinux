#!/bin/bash
sudo setenforce 0
mkdir -p build
ksflatten -c ./turtlinux.ks -o ./build/flat-turtlinux.ks
cd build
rm -rf ./iso_out
sudo livemedia-creator \
    --make-iso \
    --ks=./flat-turtlinux.ks \
    --no-virt \
    --resultdir=./iso_out \
    --project=TurtLinux \
    --releasever=44 \
    --iso-only \
    --iso-name=turtlinux-live.iso
sudo setenforce