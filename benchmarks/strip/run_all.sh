#!/usr/bin/env bash

for L in {1..5}; do
  for sample in {1..100}; do
    echo "====================================="
    echo "running L $L sample $sample"
    echo "====================================="
    mpiexec -n 10 ../../raccoon-opt -i strip.i L=$L sample=$sample
  done
done
