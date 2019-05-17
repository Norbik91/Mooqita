#!/bin/bash

# Variable FILE_NAME containes path and name of the file to be created
FILE_NAME="/tmp/file1"
# Create empty file to contain series of random numbers and strings of characters.
echo -n "" > $FILE_NAME

#Create CHARS variable - the string containing all possible characters in lines.
CHARS="0123456789ABCDEFGHIGKLMNOPQRSTUVWXYZabcdefghigklmnopqrstuvwxyz"
# ${#CHARS} construction returns length of CHARS string.
CHARS_LEN=${#CHARS}

# FSIZE variable contains size of file (in kilobytes). In the begining size of file is 0.
FSIZE="0"

# Data will be created while size of file (in kilobytes) is less than 1024.
while [[ $FSIZE -lt 1024 ]]; do
	# Variable LINE_LEN containes randomly chosen number of characters in each line.
	# It's created by random number modulated by 15 (0..14) and added by 1 (1..15).
	LINE_LEN=$(( (RANDOM%15)+1 ))

	# Creating each line with For loop.
	# For each line number of turns in the loop depends on LINE_LEN variable.
	for i in $(seq 1 $LINE_LEN); do
		# Variable LINE_STR accumulates string of characters for each line by appending \
		# to itself randomply chosen character from CHARS variable each turn.
		# Construction ${CHARS:RANDOM%$CHARS_LEN:1} takes one character from CHARS \
		# with random offset. Offset is a random number modulated by length of CHARS.
		LINE_STR="$LINE_STR${CHARS:RANDOM%$CHARS_LEN:1}"
	done

	# Append newly created string to a $FILE_NAME.
	echo $LINE_STR >> $FILE_NAME

	# Clean the variable LINE_STR to be able to create new line.
	LINE_STR=""

	# Checking the size of file could be performed by (stat) or (wc) command.
	# %s format returns size of file in bytes.
	# Dividing result by 1024 FSIZE saves size in kilobytes.
	FSIZE=$(( $(stat -c'%s' $FILE_NAME) /1024 ))

	# Check size of file using wc command (in kilobytes)
	FSIZE_WC=$(( $(wc -c < "$FILE_NAME") /1024 ))
done

# To sort the file (sort) command can be used. It's the most common command in Linux to sort file.
# Without any option it will sort in alphabetical order.
# -o option allows to indicate the output file (the same file in this case).
sort -o $FILE_NAME $FILE_NAME


NEW_FILE="/tmp/file2"
# From $FILE_NAME find out all the lines with first character (a) or (A), \
# delete these lines and write down the rest to a $NEW_FILE.
sed '/^[aA]/d' $FILE_NAME > $NEW_FILE

# Find number of removed lines:
# Count number of lines in the original file and subtract number of lines in the $NEW_FILE.
LINES_REMOVED=$(( $(wc -l < "$FILE_NAME") - $(wc -l < "$NEW_FILE") ))
echo "Lines removed:" $LINES_REMOVED
