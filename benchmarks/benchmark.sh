#!/bin/sh

set -ex

which mpicc
which mpirun
nvidia-smi  -q -i 0 -d CLOCK
nvidia-smi topo --matrix

for nproc in $(echo "2 4 8" | tr " " "\n"); do
    mpirun --bind-to none -n $nproc luajit ./test/collectives.lua -all
    mpirun --bind-to none -n $nproc luajit ./test/collectives.lua -all -gpu
done
