#!/bin/bash

USERS=($(cut -d: -f1,3 /etc/passwd))

UID_MIN_DATA=($(grep -E '^UID_MIN' /etc/login.defs |  tr -s " " "\012"))
UID_MIN=${UID_MIN_DATA[1]}

for user in "${USERS[@]}"; do
	data=($(echo $user | tr ":" "\n"))
	user_groups=($(groups "${data[0]}" | tr ":" "\n" | tr -s " " "\n"))
	trimmed_groups=("${user_groups[@]:1}")
	if [[ "${data[1]}" -ge $UID_MIN ]]; then
		printf "\033[1;35m${data[0]}\033[0m\t"
		if [[ "${#trimmed_groups[@]}" -gt 1 ]]; then
			for group in "${trimmed_groups[@]:1}"; do printf "$group\t"; done
			printf "\nwhat groups would you like to remove?\t"
			read gz
			if [[ -n $gz ]]; then
				gpasswd --delete "${data[0]}" $gz
			fi
		fi
		echo
	fi
done