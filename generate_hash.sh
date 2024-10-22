#!/bin/bash

# Check if a filename is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

FILE="$1"

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

# Compute the MD5 checksum
if command -v md5sum &> /dev/null; then
    # For Linux
    MD5_HASH=$(md5sum "$FILE" | awk '{ print $1 }')
elif command -v md5 &> /dev/null; then
    # For macOS
    MD5_HASH=$(md5 -q "$FILE")
else
    echo "MD5 command not found. Please install md5 or md5sum."
    exit 1
fi

# Output the MD5 checksum
echo "$MD5_HASH" > HASH