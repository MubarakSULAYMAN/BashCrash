#!/bin/bash

# Uncomment next line to request to download file
# wget http://www.bom.gov.au/climate/dwo/201905/text/IDCJDW6111.201905.csv
# "wget" is for a non interractive download i.e, you do not control the download process

# Move to your file directory, open it and select desired columns
awk -v OFS="   " -F"," '{print $2, $3, $4, $7}' /home/mubarak/Documents/IDCJDW6111.201905.csv | sort -n
# "'{print $2, $3, $4, $7}'" defines my enjoyable - so I arranged them in order of minimum temperature
# "/home/mubarak/Documents/" is the folder directory it is downloaded
# "awk" helps selects desired colums, "sort" helps with sorting, "OFS" is to change the separator as specified by "-F",
# "-n" compares according to string numerical value,

# It should expect to receive lines on standard input, where each line contains two
# columns, separated by commas; the first column should be a date
# (in YYYY-MM-DD format), and the second either the word “unenjoyable” or
# “enjoyable”.
# For example:
# 2019-03-01,enjoyable
# 2019-03-02,unenjoyable
# 2019-03-03,enjoyable
# This means your scripts could be put in a pipeline, weekends.sh |
# weather_analyser.sh, to get a single line of output, either “supported” or
# “unsupported”.