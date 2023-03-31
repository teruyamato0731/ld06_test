#!/bin/bash
set -euxo pipefail
cd "${BASH_SOURCE[0]%/*}"/..
git submodule update --init

sudo gpasswd --add $USER dialout
