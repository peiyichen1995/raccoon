#!/usr/bin/env bash

file="rn.txt"


while read -r line; do
  #Reading each line
  echo "====================================="
  echo "running $line"
  echo "====================================="
  mpiexec -n 50 ../../raccoon-opt -i strip.i $line </dev/null

done < $file
