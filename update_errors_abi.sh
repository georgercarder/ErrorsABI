#!/bin/sh

targetFilepath="$1"

if [ -z "$targetFilepath" ]; then
  echo "update errors abi: must include targetFilePath as first arg"
  exit 1
fi

echo "updating errors abi"
echo "this can take a few seconds..."

files=$(ls out)

declare -A uniqueMap

ret="[]"

for f in ${files[@]}; 
do
    hasSol=$(echo "$f" | grep ".sol")
    if [ -z "$hasSol" ]; then
        continue
    fi

    abis=$(ls "out/""$f")

    for a in ${abis[@]};
    do
        path="out/""$f""/""$a"
        LEN=$(cat "$path" | jq '.abi | length')
        for (( i = 0; i < $LEN; i++)); do
          elt=$(cat "$path" | jq ".abi[$i]")
          _type=$(echo "$elt" | jq '.type')

          if [ "${_type}" != '"error"' ]; then
              continue
          fi

          mapped=${uniqueMap["$elt"]}
          if [ ! -z "$mapped" ]; then
              continue
          fi
          uniqueMap["$elt"]="1"

          elt=$(echo "$elt" | xargs -d'\n' | sed 's/ //g') # takes out return carriages 

          ret=$(echo "$ret" | jq ". += ["$elt"]")
        done

    done
done

echo '"use strict";' > "$targetFilepath"
echo '' >> "$targetFilepath"
echo '' >> "$targetFilepath"

echo "export const ErrorsABI = ""$ret"";" >> "$targetFilepath" 

echo "update errors done"
