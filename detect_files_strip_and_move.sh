#!/bin/bash

# Finds files, strips out special characters and then places these files in a
# desired location.

echo;
echo Executing $0 ...;
echo;

# Place the file extensions you want to find here eg "*.txt".
file_type_1="";
file_type_2="";
file_type_3="";

# If there is a portion of the file name you wish to strip away (up until the extension)
# place a capture group here.
strip_after_point="";

if [ -z "$file_type_1" ] && [ -z "$file_type_2" ] && [ -z "$file_type_3" ]; then
    echo "ERROR: You should include file types to grab or else this program won't work!!";
    exit 1;
fi;


# Capture params.
from=$1;
move_to=$2;

echo With params:;
echo $from;
echo $move_to;
echo;
echo Sanitizing names...;

# First remove invalid periods.
find $from -maxdepth 2 -type f \( -iname "${file_type_1}" -o -iname "${file_type_2}" -o -iname "{$file_type_3}" \) -execdir rename -v 's/(?<!^)\.(?=.*\.)/ /g' {} \;
# Then Remove special characters.
find $from -maxdepth 2 -type f \( -iname "${file_type_1}" -o -iname "${file_type_2}" -o -iname "${file_type_3}" \) -execdir rename -v 's/[^A-Za-z0-9 \.\/]//g' {} \;

if [ -n "$strip_after_point" ]; then
    # Next remove any nonsense between the name and the extension.
    find $from -maxdepth 2 -type f \( -iname "${file_type_1}" -o -iname "${file_type_2}" -o -iname "${file_type_3}" \) -execdir rename -v 's/(?<!^)('$strip_after_point').*(?=.*\.)/$1/g' {} \;
fi;

# Finally remove the last extra space in between the name and the extension.
find $from -maxdepth 2 -type f \( -iname "${file_type_1}" -o -iname "${file_type_2}" -o -iname "${file_type_3}" \) -execdir rename -v 's/ +(\.[^.]+)$/$1/g' {} \;

echo Sanitizing finished.;
echo;

echo Beginning transfers...;
echo;
# Find the sanitized files and place them in our desired location.
find $from -maxdepth 2 -type f \( -iname "${file_type_1}" -o -iname "${file_type_2}" -o -iname "${file_type_3}" \) | while IFS= read -r file; do
    echo "Moving "\"${file}\" file to \"${move_to}\";
    mv "${file}" "${move_to}";
done;

echo;
echo Completed.;
