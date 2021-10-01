#!/bin/bash

# this script copies all files from all users either root or uid >= 1000

OUT_DIR="saved"

mkdir -p "$OUT_DIR"

for i in $(cut -d: -f1,3,6 /etc/passwd); do
  split=($(echo "$i" | tr ":" "\n"))
  if [[ ${split[1]} -ge 1000 || ${split[1]} -eq 0 ]]; then
      user="${split[0]}"
      printf "\033[1;35mcopying into \033[0m$OUT_DIR/$user\n"
      mkdir -p "$OUT_DIR/$user"
      cp -r "${split[2]}/" "$OUT_DIR/$user" 2>/dev/null
  fi
done