#!/usr/bin/env bash

OS=$(uname | tr "[:upper:]" "[:lower:]")
VERSION="stable"
ARCH=$(uname -m)
COMMAND="shellcheck"
SHELLCHECK_FILE=https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-${VERSION}.${OS}.${ARCH}.tar.xz

test -e ./bin/${COMMAND} ||
  {
    wget -qO- "${SHELLCHECK_FILE}" | tar xJC bin
    mv ./bin/${COMMAND}-${VERSION}/${COMMAND} ./bin
    chmod +x ./bin/${COMMAND}
    rm -r ./bin/${COMMAND}-${VERSION}
  }

echo "./bin/${COMMAND}: $(./bin/${COMMAND} --version)"
