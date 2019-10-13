#!/bin/bash
grep -o -E '\w+' 'cd ~/unix-1969-1971.txt'

# change "'~/unix-1969-1971.txt'" to your choiced directory, e.g 'josh/unix.txt'
# add " | sort -u -f" if you want each word to appear once, disregarding case
# "grep" searches a file for a particular pattern of characters, displays lines that contains it and filters.
# '\w+' searches for words, "-o" only prints the portion of the line that matches % cat temp