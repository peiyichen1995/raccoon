#!/usr/bin/env bash

file="rn_cv.txt"


while read -r line; do
  #Reading each line
  echo "====================================="
  echo "running $line"
  echo "====================================="
  mpiexec -n 50 ../../raccoon-opt -i vascular.i $line

done < $file
