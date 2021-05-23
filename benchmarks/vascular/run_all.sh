#!/usr/bin/env bash

file="rn.txt"


while read -r line; do
  #Reading each line
  echo "====================================="
  echo "running $line"
  echo "====================================="
  mpiexec -n 74 ../../raccoon-opt -i vascular.i $line > output.txt &

done < $file
