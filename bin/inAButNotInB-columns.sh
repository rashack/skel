#!/bin/bash

C1=$1
C2=$2
F1=$3
F2=$4

# Print all rows from $F2 that does not have an element in column $C2
# that exists in column $C1 in $F1

awk '
BEGIN {
  while ((getline < "'$F1'") > 0) {
    f1array[$'$C1'] = $'$C1';
  }
}

{
  if (!f1array[$'$C2'])
    print $0;
}
' $F2
