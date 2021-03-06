#!/bin/sh

# stop if something goes wrong
set -e 

if type kodictl >/dev/null 2>&1; then 
  # if kodictl is already in the $PATH, use it
  kodictl notify "raptiformica `hostname`" "$@"
else
  # move to a dir where we can check out some stuff
  mkdir -p /usr/etc/raptiformica-notify-kodi
  cd /usr/etc/raptiformica-notify-kodi

  # Install racket 6.6 if no racket is installed
  if ! type racket >/dev/null 2>&1; then 
      wget -nc https://mirror.racket-lang.org/installers/6.6/racket-minimal-6.6-x86_64-linux.sh
      sh racket-minimal-6.6-x86_64-linux.sh --unix-style --create-dir --dest /usr/
  fi

  # install srfi-lite-lib if it is not installed yet
  raco pkg show | grep srfi-lite-lib || raco pkg install --deps force srfi-lite-lib

  # force install the json-rpc-client racket package if there is no checkout on disk 
  if [ ! -d json-rpc-client ]; then
      git clone https://github.com/vdloo/json-rpc-client &&\
      (cd json-rpc-client &&\
      raco pkg install --deps force || /bin/true)
  fi

  # create a kodictl checkout if the directory does not exist
  if [ ! -d kodictl ]; then
      git clone https://github.com/vdloo/kodictl
  fi
  racket kodictl/kodictl/main.rkt notify "raptiformica `hostname`" "$@"
fi

