#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

source "./_includes.sh"

if [ "$OS_NAME" = "linux32" ]; then PORT=8032; fi
if [ "$OS_NAME" = "linux64" ]; then PORT=8064; fi

(
    cd "$OUTDIR"

    echo "Serving the following files:"
    for filename in *; do
        URL="http://$PRIMARY_IP:$PORT/$filename"
        HASH=$(sha1sum "$filename" | cut -d" " --fields=1)
        echo "  wget $URL -O $filename.part && (sha1sum $filename.part | grep $HASH) && mv $filename.part $filename"
    done

    python3 -m http.server "$PORT"
)
