set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi


make init -f /usr/local/bin/actions.mk
