#!/bin/sh -e 
# include parse_yaml function
. ../lib/parse_yaml.sh

# read yaml file
eval $(parse_yaml test.yaml "config_")

# access yaml content
if [ -n "$config_string" ]
then
  echo $config_string
fi
if [ -n "$config_test_string" ]
then
  echo $config_test_string
fi
# array
if [[ "$(declare -p config_array)" =~ "declare -a" ]]
then
  echo ${config_array[*]}
fi
if [[ "$(declare -p config_test_array)" =~ "declare -a" ]]
then
  echo ${config_test_array[*]}
fi
