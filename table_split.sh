#!/bin/bash

let MAX_INSERT_SIZE="10 * 1024 * 1024"

INSERT_COMMAND=$(cat $1 | grep INSERT)
RECORD_SIZE=$(cat $1 | grep -A 1 'INSERT.*' | head -n 2 | wc -c)
MAX_INSERT_LINES_COUNT=$(($MAX_INSERT_SIZE / $RECORD_SIZE))
PARTS=$(($(cat $1 | wc -l) / $MAX_INSERT_LINES_COUNT))
let PARTS_DV=$(($(cat $1 | wc -l) % $MAX_INSERT_LINES_COUNT))
if [ $PARTS_DV -lt 100 ]
then
 PARTS=$(($PARTS - 1))
fi
for ((i = 1; i <= $PARTS; i++)); do
 POSITION=$(($i * $MAX_INSERT_LINES_COUNT))
 sed -i -s "${POSITION}s/)\,/)\;\n$INSERT_COMMAND/" $1
done
