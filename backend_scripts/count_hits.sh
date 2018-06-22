#!/usr/bin/env bash

SAMFILES=$1

for i in $SAMFILES/*.sam; do

echo $i
grep "^[^@;]" $i | awk '{ print $3 }' |  sort | uniq -c | sort -nr > $i.hitcount.txt;

done 
