@'
#!/bin/sh
set -eu

if [ $# -eq 0 ]; then
    set -- chronyd
elif [ $# -gt 0 ] && [ "$1" = 'chronyd' ]; then
    shift
    set -- chronyd "$@"
elif [ $# -gt 0 ] && [ "${1#-}" != "$1" ]; then
    # A flag starting with '-' was passed
    set -- chronyd "$@"
fi

echo "Executing: $@"
exec "$@"

'@
