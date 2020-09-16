#!/usr/bin/env bash

file='rn.txt'


while read line; do

#Reading each line
mpiexec -n 50 ../../raccoon-opt -i strip.i $line

done < $file
