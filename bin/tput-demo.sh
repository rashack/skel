#!/bin/bash

function fancy {
    tput $1
    echo "tput $1"
    tput sgr0
}

for c in {0..32} ; do
    fancy "setaf $c"
done

for c in {0..32} ; do
    fancy "setab $c"
done

# smul/rmul, smso/rmso
TPUTS="bold dim smul rev smso"
for c in $TPUTS ; do
    fancy "$c"
done

for x in {1..30} ; do
    if ! (( $x % 10 )) ; then
	echo -n $(( $x / 10 ))
    else
	echo -n " "
    fi
done
echo
for x in {1..30} ; do
    echo -n $(( $x % 10 ))
done
echo

echo -n A
tput cuf 9
echo -n C
tput cub 6
echo -n B
tput cuf 9
echo -n D
echo
