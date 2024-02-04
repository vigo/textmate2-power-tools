#!/usr/bin/env bash
#
# Created by Uğur "vigo" Özyılmazel on 2024-09-26.
# Copyright (c) 2024 VB YAZILIM, All rights reserved.

set -e
set -o pipefail
set -o errexit
set -o nounset

go install golang.org/x/tools/cmd/goimports@latest &&
echo "[goimports] installed"

go install mvdan.cc/gofumpt@latest &&
echo "[gofumpt] installed"

go install github.com/segmentio/golines@latest &&
echo "[golines] installed"

