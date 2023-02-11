#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive apt-get --option Acquire::Retries=60 --option Acquire::http::Timeout=180 --option APT::Get::Install-Recommends=false --option APT::Get::Install-Suggests=false --yes "$@"
