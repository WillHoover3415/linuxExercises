#!/bin/bash

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "usage: $0 <column> [file.csv]" 1>&2
    exit 1
fi

column=$1

if [ "$#" -eq 2 ]; then
    file="$2"
else
    file="/dev/stdin"
fi

cat "$file" | cut -d',' -f"$column" | tail -n +2 | {
    sum=0
    count=0
    while read value; do
        if [ -n "$value" ]; then
            sum=$(echo "$sum + $value" | bc -l)
            count=$((count + 1))
        fi
    done
    if [ "$count" -gt 0 ]; then
        echo "$sum / $count" | bc -l
    fi
}
