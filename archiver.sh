#!/usr/bin/env bash

temp=/tmp/archiver.list
# include parse_yaml function
. lib/parse_yaml.sh

# Loading modules
for i in $(ls -1 modules/*.sh); do . $i; done 

# ==========  functions
function pattern_to_file_list {
  test -f $temp && rm $temp
  for j in ${config_pattern_include[*]}
  do
    echo "[Pattern] $j"
    pattern=$(echo $j | tr -d "'")
    for file in $pattern
    do
      test -f $file && echo $file >> $temp
    done
  done
}

#function sleep_a_while  {
#    miutes_to_sleep=$[ ( $RANDOM % 500 ) + 10 ]
#    echo "Sleep for $miutes_to_sleep minutes..."
#    sleep "$miutes_to_sleep"m
#}

#sleep_a_while

# read (default) yaml file
for i in $(ls -1 conf.d/*.yaml); do eval $(parse_yaml $i "config_"); done

# host data
hostname=$(hostname -f)

# generate file list
pattern_to_file_list

for i in ${config_protocol[*]}
do
  set -e
  ${i}_config 
  ${i}_test

  # Loop through list of files..
  for file in $(cat $temp); do ${i}_copy $file; done
done

test -f $temp && rm $temp && exit 0
