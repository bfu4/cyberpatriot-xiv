#!/bin/bash

# arguments
ARGS=$@
FOUND=()
ELSE=()

if [[ $EUID -ne 0 ]]; then
	printf "\033[1;35mthis command must be run as root!\033[0m\n"
	exit 1
fi

UID_MIN_DATA=($(grep -E '^UID_MIN' /etc/login.defs |  tr -s " " "\012"))
UID_MIN=${UID_MIN_DATA[1]}

USERS=($(cut -d: -f1,3 /etc/passwd))

# iterate
for u in "${USERS[@]}"; do
	user=($(echo $u | tr ":" "\n"))
	if [[ "${user[1]}" -ge $UID_MIN ]]; then
		name="${user[0]}"
		if [[ "${ARGS[@]}" =~ "$name" ]]; then
			FOUND+=("$name")
		else
			ELSE+=("$name")
		fi
	fi
done

for el in "${ELSE[@]}"; do
	printf "\033[1;35munrecognized\033[0m\t$el\n"
done

# iterate through arguments and array of found users
for user in $ARGS; do
	if [[ ! "${FOUND[@]}" =~ (^|[[:space:]])"$user"($|[[:space:]])  ]]; then
		printf "\033[1;33mdid not find\033[0m\t$user\n\033[1;37mwould you like to add them? (y/n, default n)\033[0m\t"
		read yn
		case $yn in
			[Yy]* ) useradd -m $user; printf "\033[1;32madded \033[0m$user\033[1;32m with home /home/$user\033[0m\n";;
		esac
	else
		printf "\033[1;32mfound\033[0m\t$user\n"
	fi
done