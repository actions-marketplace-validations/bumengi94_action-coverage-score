#!/bin/sh

totalLine=0
totalScore=0

while read -r line; do
	if [ "${line#LF:}" != "$line" ] || [ "${line#FNF:}" != "$line" ] || [ "${line#BRF:}" != "$line" ]; then
		totalLine=$(($(echo "$line" | cut -d ":" -f 2) + totalLine))
	fi
	if [ "${line#LH:}" != "$line" ] || [ "${line#FNH:}" != "$line" ] || [ "${line#BRH:}" != "$line" ]; then
		totalScore=$(($(echo "$line" | cut -d ":" -f 2) + totalScore))
	fi
done < "./coverage/lcov.info"

result=$(echo "scale=2; $totalScore * 100 / $totalLine" | bc)


echo "score=$result" >> "$GITHUB_OUTPUT"
