#!/usr/bin/env bash

# make.sh
#
# Copyright (C) 2023 Kristofer Berggren
# All rights reserved.
#
# See LICENSE for redistribution information.

# exiterr
exiterr()
{
  >&2 echo "${1}"
  exit 1
}

# process arguments
DEPS="0"
BUILD="0"
case "${1%/}" in
  deps)
    DEPS="1"
    ;;

  build)
    BUILD="1"
    ;;

  all)
    DEPS="1"
    BUILD="1"
    ;;

  *)
    echo "usage: make.sh <deps|build|all>"
    echo "  deps      - install project dependencies"
    echo "  build     - perform build"
    exit 1
    ;;
esac

# deps
if [[ "${DEPS}" == "1" ]]; then
  OS="$(uname)"
  if [ "${OS}" == "Linux" ]; then
    unset NAME
    eval $(grep "^NAME=" /etc/os-release 2> /dev/null)
    if [[ "${NAME}" == "Ubuntu" ]]; then
      sudo apt update && sudo apt install jekyll ruby-dev
    else
      exiterr "deps failed (unsupported linux distro ${NAME}), exiting."
    fi
  elif [ "${OS}" == "Darwin" ]; then
    #HOMEBREW_NO_AUTO_UPDATE=1 brew install ...
    echo "deps macos to be implemented"
  else
    exiterr "deps failed (unsupported os ${OS}), exiting."
  fi
fi

# build
if [[ "${BUILD}" == "1" ]]; then
  bundle install || exiterr "bundle install failed"
  bundle exec jekyll build || exiterr "bundle exec failed"
  echo ""
  echo "Output files available in _site"
  echo "file://$(pwd)/_site"
  echo ""
fi

# exit
exit 0
