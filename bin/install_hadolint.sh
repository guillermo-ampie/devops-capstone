#!/usr/bin/env bash

OS=$(uname)
VERSION="v1.22.1"
HADOLINT_FILE=https://github.com/hadolint/hadolint/releases/download/${VERSION}/hadolint-${OS}-x86_64

test -e ./bin/hadolint ||
  {
    wget -qO ./bin/hadolint "${HADOLINT_FILE}"
    chmod +x ./bin/hadolint
  }

echo "./bin/hadolint: $(./bin/hadolint --version)"
