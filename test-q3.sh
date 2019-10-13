#!/usr/bin/env bash

function warning {
  printf '\x1b[91;45;1m\x1b[4mWARNING: %s, exiting now\x1b[0m\n' "$*"
}

function good {
  printf '\x1b[92;44;1m\x1b[4m%s\x1b[0m\n' "$*"
}

function header {
  printf '\x1b[94;44;1m\x1b[4m%s\x1b[0m\n' "$*"
}

# q3

function q3a_test {

  local expected_script_name="weekends.sh"

  header '###Question 3, part A###'
  echo

  if [[ ! -f "$expected_script_name" ]]; then
    warning "No $expected_script_name script found"
    exit 1
  elif [[ ! -x "$expected_script_name" ]]; then
    warning "$expected_script_name script found, but is not executable - you need to chmod it"
    exit 1
  fi

  #tempdir=$(mktemp -d q3a-testdata.XXXXXX)

  local result=$("./$expected_script_name");

  {
    num_lines=$(echo "$result" | wc -l) 
  } >/dev/null 2>/dev/null

  if [[ $num_lines -lt 2 ]]; then
    printf "\nYour script does not produce any output! That doesn't seem right.\n"
    warning "no output"
    exit 1
  fi

  {
    lines_with_dates=$(echo "$result" | grep -P '\d\d\d\d-\d\d-\d\d' | wc -l)
  } >/dev/null 2>/dev/null

  if [[ $lines_with_dates -lt $num_lines ]]; then
    msg=$(sed 's/^\s\+//' <<HERE
    All the lines outputted by your script should have contained dates of the form
    YYYY-MM-DD, but only $lines_with_dates of $num_lines did.

    Bad output lines:
    $(echo "$result" | cat -n | grep -v -P '\d\d\d\d-\d\d-\d\d')
HERE
)
    printf '\n%s\n\n' "$msg";
    warning "lines without dates found"
    exit 1
  fi

  {
    lines_with_first_col_dates=$(echo "$result" | grep -P '^\d\d\d\d-\d\d-\d\d,' | wc -l)
  } >/dev/null 2>/dev/null

  if [[ $lines_with_first_col_dates -lt $num_lines ]]; then
    msg=$(sed 's/^\s\+//' <<HERE
    All the lines outputted by your script should have started with dates of the form
    YYYY-MM-DD, and then a comma, but only $lines_with_first_col_dates of $num_lines did.

    Bad output lines:
    $(echo "$result" | cat | grep -v -P '^\d\d\d\d-\d\d-\d\d,')
HERE
)
    printf '\n%s\n\n' "$msg";
    warning "lines not starting with dates found"
    exit 1
  fi

  {
    lines_with_two_cols=$(echo "$result" | grep -P '^[^,]+,[^,]+$' | wc -l)
  } >/dev/null 2>/dev/null

  if [[ $lines_with_two_cols -lt $num_lines ]]; then
    msg=$(sed 's/^\s\+//' <<HERE
    All the lines in your script's output should have contained two columns,
    separated by a comma; but only $lines_with_two_cols of $num_lines did.

    Bad output lines:
    $(echo "$result" |  grep -v -P '^[^,]+,[^,]+$')
HERE
)
    printf '\n%s\n\n' "$msg";
    warning "lines not containing two columns found"
    exit 1
  fi

  {
    lines_with_enjoyablecol=$(echo "$result" | grep -P '(un)?enjoyable' | wc -l)
  } >/dev/null 2>/dev/null

  if [[ $lines_with_enjoyablecol -lt $num_lines ]]; then
    msg=$(sed 's/^\s\+//' <<HERE
    All the lines in your script's output should have contained either the word
    'enjoyable' or the word 'unenjoyable'; but only $lines_with_enjoyablecol of $num_lines did.

    Bad output lines:
    $(echo "$result" |  grep -v -P '(un)?enjoyable')
HERE
)
    printf '\n%s\n\n' "$msg";
    warning "lines found missing the words (un)enjoyable"
    exit 1
  fi

  {
    lines_with_exactformat=$(echo "$result" | grep -P '^\d\d\d\d-\d\d-\d\d,(un)?enjoyable$' | wc -l)
  } >/dev/null 2>/dev/null

  if [[ $lines_with_exactformat -lt $num_lines ]]; then
    msg=$(cat <<HERE
All the lines in your script's output should have been *EXACTLY* of the format

  YYYY-MM-DD,RESULT

where 'RESULT' was either the word "enjoyable" or the word "unenjoyable".
But only $lines_with_exactformat of $num_lines did.

Bad output lines:
$(echo "$result" |  grep -v -P '^\d\d\d\d-\d\d-\d\d,(un)?enjoyable$')
HERE
)
    printf '\n%s\n\n' "$msg";
    warning "lines found with incorrect format"
    exit 1
  fi

  if [[ $num_lines -gt 31 ]]; then
    msg=$(sed 's/^\s\+//' <<HERE
    Your script produced more than 31 lines of output. But there are no months
    with more than 31 days. Is there a mistake in your output? 
HERE
)
    printf '\n%s\n\n' "$msg";
    warning "too many output lines"
    exit 1

  fi

  {
  dupedates=$(echo "$result" | cut -d',' -f1 | sort | uniq -d)
  } >/dev/null 2>/dev/null

  {
  dupedates_count=$(echo "$result" | cut -d',' -f1 | sort | uniq -d | wc -l)
  } >/dev/null 2>/dev/null

  if [[ $dupedates_count -gt 0 ]]; then
    msg=$(sed 's/^\s\+//' <<HERE
    Your script seems to have outputted more than one line for the same date.
    That doesn't seem right - is there a mistake in your logic?

    Duplicated dates:
    $(echo $dupedates) 
HERE
)
    printf '\n%s\n\n' "$msg";
    warning "duplicated dates"
    exit 1
  fi

  {
  unenjoyable_days=$(echo "$result" | grep unenjoyable | wc -l)
  } >/dev/null 2>/dev/null

  unenjoyable_percent=$(echo "scale=3; res=$unenjoyable_days * 100.0 / $num_lines; scale=0; res/1" | bc)

  printf "It looks like your script classifies %d percent of days as unenjoyable\n" $unenjoyable_percent

  if [[ $unenjoyable_percent -lt 6 || $unenjoyable_percent -gt 94 ]]; then
    msg=$(sed 's/^\s\+//' <<HERE
    That seems a bit extreme, but okay.
HERE
)
    printf '\n%s\n\n' "$msg";
  fi

  good "Looking good"

  printf '\nThe output from your script seems reasonable so far.\n\n\n'

}

q3a_test

function q3b_test {

  local expected_script_name="weather_analyser.sh"

  header '###Question 3, part B###'
  echo

  if [[ ! -f "$expected_script_name" ]]; then
    warning "No $expected_script_name script found"
    exit 1
  elif [[ ! -x "$expected_script_name" ]]; then
    warning "$expected_script_name script found, but is not executable - you need to chmod it"
    exit 1
  fi

  #tempdir=$(mktemp -d q3b-testdata.XXXXXX)

  result=$(
    {
    for ((i=1; i < 29; i=i+1)); do
      if [[ $i -lt 14 ]]; then
        printf '2019-04-%02d,unenjoyable\n' $i
      else
        printf '2019-04-%02d,enjoyable\n' $i
      fi
    done
    } | "./$expected_script_name"
  );

  if [[ ! $result =~ ^[[:space:]]*(un)?supported[[:space:]]* ]]; then
    msg=$(sed 's/^\s\+//' <<HERE
    The script is supposed to output just one word, either "supported"
    or "unsupported", which your script doesn't do -- is there a mistake
    in your logic?

    The output was:
    $result
HERE
)
    printf '\n%s\n\n' "$msg";

    warning "bad output"
    exit 1

  fi

  good "Looking good"

  printf '\nThe output from your script seems reasonable so far.\n\n\n'

}

q3b_test



