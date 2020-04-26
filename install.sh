#!/usr/bin/env bash
set -e
set -o pipefail


PREFIX="/usr/local"

usage() {
cat << EOT
usage: $0 [prefix]

default prefix: /usr/local
EOT

exit 1
}

if [ "$1" = "-h" -o  "$1" = "--help" ]; then
    usage
fi

if [ ! -z "$1" ]; then
    PREFIX="$1"
fi
echo "Installing ktcpdump in directory $PREFIX"

if [ ! -d "$PREFIX" ]; then
    echo "Directory $PREFIX does not exist"
    usage
fi

abspath=$(cd "$(dirname "$0")" >/dev/null 2>&1; pwd -P)
mkdir -p "$PREFIX"/{ktcpdump,bin}
cp -R "$abspath"/* "$PREFIX"/ktcpdump
ln -sf "$PREFIX"/ktcpdump/ktcpdump "$PREFIX"/bin/ktcpdump

echo "Done!"