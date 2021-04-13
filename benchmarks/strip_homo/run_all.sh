#!/usr/bin/env bash

file="rn_mle_100.txt"


while read -r line; do
  #Reading each line
  echo "====================================="
  echo "running $line"
  echo "====================================="
  mpiexec -n 2 ../../raccoon-opt -i media_circ_half.i $line </dev/null

done < $file
