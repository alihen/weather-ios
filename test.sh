#!/usr/bin/env bash
set -fu
set -o pipefail

bash <(curl -s https://codecov.io/bash) -t $CODECOV_TOKEN -J Weather
