#!/bin/bash
# @author Addshore
# Check all .sh files for the +x bit

failed=false

for file in $( find . -type f -name '*.sh' ); do
    if [[ -x "$file" ]]
    then
        echo "File '$file' is executable"
    else
        echo "File '$file' is not executable"
        failed=true
    fi
done

if [[ $failed == true ]]
then
    echo "Failed: not all .sh files have +x"
    exit 1
fi