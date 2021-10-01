#!/bin/bash

# this script basically copies the files from specified users (where each user is an argument, etc)

OUT_DIR="saved"
# copy arguments
ARGS=$@

# make our out directory
mkdir -p "$OUT_DIR"

# iterate in users
for i in $ARGS; do
  # get line from /etc/passwd
  found=$(cat /etc/passwd | grep "$i")
  # if it exists then we can mess with it
  if [[ -n "$found" ]]; then
	stripped=$(echo "$found" | cut -d: -f1,3,6 -)
  	split=($(echo "$stripped" | tr ":" "\n"))
	# check uid, users start at 1000, root is 0
  	if [[ ${split[1]} -ge 1000 || ${split[1]} -eq 0 ]]; then
  		user="${split[0]}"
  		printf "\033[1;35mcopying into \033[0m$OUT_DIR/$user\n"
		# ok troll
  		cp -r "${split[2]}/" "$OUT_DIR/$user" 2>/dev/null
	fi
  fi
done
