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

# q1

function q1_test {

  expected_script_name="ls_by_size.sh"

  header '###Question 1###'
  echo

  if [[ ! -f "$expected_script_name" ]]; then
    warning "No $expected_script_name script found"
    exit 1
  elif [[ ! -x "$expected_script_name" ]]; then
    warning "$expected_script_name script found, but is not executable - you need to chmod it"
    exit 1
  fi

  tempdir=$(mktemp -d q1-testdata.XXXXXX)
  (dd if=/dev/zero of="$tempdir/small" bs=1M count=5
  dd if=/dev/zero of="$tempdir/medium" bs=1M count=10
  dd if=/dev/zero of="$tempdir/large" bs=1M count=15) 1>/dev/null 2>/dev/null
  result=$(./"$expected_script_name" "$tempdir/small" \
            "$tempdir/medium" \
            "$tempdir/large")
  result_len=$(echo "$result" | wc -l)

  if [[ "$result_len" != 3 ]]; then
    warning "expected to get 3 lines of output, got $result_len"
    exit 1
  fi

  expected_words=(large medium small);
  
  echo "$result" | {
    for ((i=0; $i < 3; i=$i+1)); do
      read line
      line_no=$(($i + 1))
      expected_word="${expected_words[$i]}"
      if [[ $line != *${expected_word}* ]]; then
        warning "Expected line no. $line_no to contain the string '$expected_word'," \
          "but it didn't"
        exit 1
      fi
    done
  }

  printf '\n\n'
  good "Your question 1 script has passed all tests ... so far."

}

q1_test

