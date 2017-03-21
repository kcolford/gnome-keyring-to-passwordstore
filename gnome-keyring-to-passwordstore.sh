#!/bin/bash

umask 0077
secret-tool search --all type 0 |& {
    domain=""
    user=""
    password=""
    while read -r attr _ val; do
	case "$attr" in
	    "["*)
		if [ "$domain" ] && [ "$user" ] && [ "$password" ]; then
		    echo "$password" | pass insert -m "$domain"/"$user"
		    #echo "$domain" "$user" "$password"
		fi
		domain=""
		user=""
		password=""
		;;
	    "label")
		# shellcheck disable=SC2001
		domain="$(echo "$val" | sed -E 's,https://([a-z0-9-]+(\.[a-z0-9-]+)+)/.*,\1,;t;d')"
		;;
	    "secret") password="$val" ;;
	    "attribute.username_value") user="$val" ;;
	esac
    done
}

		
	    


