#!/bin/sh

sum=0
total=0

while read -r line; do
  if [ "$line" = "TN:" ]; then
    start=true
  fi
  if [ "$line" = "end_of_record" ]; then
    sum=$(echo "scale=2; $sum + ($fnfPer + $lPer + $brPer) / 3" | bc)
    total=$((total + 1))
    start=false

    fnf=0
    fnfPer=0

    lf=0
    lPer=0

    brf=0
    brPer=0
  fi
  if [ "$start" = true ]; then
    if [ "${line#FNF}" != "$line" ]; then
      fnf=$(echo "$line" | cut -d ':' -f 2)
    fi
    if [ "${line#FNH}" != "$line" ]; then
      if [ "$fnf" -eq 0 ]; then
        fnfPer=1
      else
        fnfPer=$(echo "scale=2; $(echo "$line" | cut -d ':' -f 2) / $fnf" | bc)
      fi
    fi
    if [ "${line#LF}" != "$line" ]; then
      lf=$(echo "$line" | cut -d ':' -f 2)
    fi
    if [ "${line#LH}" != "$line" ]; then
      if [ "$lf" -eq 0 ]; then
        lPer=1
      else
        lPer=$(echo "scale=2; $(echo "$line" | cut -d ':' -f 2) / $lf" | bc)
      fi
    fi
    if [ "${line#BRF}" != "$line" ]; then
      brf=$(echo "$line" | cut -d ':' -f 2)
    fi
    if [ "${line#BRH}" != "$line" ]; then
      if [ "$brf" -eq 0 ]; then
        brPer=1
      else
        brPer=$(echo "scale=2; $(echo "$line" | cut -d ':' -f 2) / $brf" | bc)
      fi
    fi
  fi
done < "$1"

result=$(echo "$sum * 100 / $total" | bc)

echo "score=$result" >> "$GITHUB_OUTPUT"
