#!/usr/bin/env bash

COMMAND="eksctl"

test -e ./bin/${COMMAND} ||
    {
        curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ./bin
        chmod +x ./bin/${COMMAND}
    }

echo "./bin/${COMMAND}: $(./bin/${COMMAND} version)"
