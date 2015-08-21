#!/bin/bash

if [ -n "$1" ]; then
  export EXIT_CODE=$1
else
  export EXIT_CODE=0
fi

function npm() {
  echo "npm $*"
  echo "npm ${EXIT_CODE}"
  return ${EXIT_CODE}
}

function fail() {
  echo "fail: $*"
}

function success() {
  echo "success: $*"
}

function warn() {
  echo "warn: $*"
}

function info() {
  echo "info: $*"
}

export -f npm fail success warn info

export NPM_EMAIL=foo@bar.com
export NPM_AUTH_TOKEN=boobar123

./run.sh
