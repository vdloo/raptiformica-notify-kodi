#!/bin/sh

# move to a dir where we can check out some stuff
mkdir -p /usr/etc/raptiformica-notify-kodi
cd /usr/etc/raptiformica-notify-kodi

# Install racket 6.6 if no racket is installed
if ! type racket 2>&1 >/dev/null; then 
    wget https://mirror.racket-lang.org/installers/6.6/racket-minimal-6.6-x86_64-linux.sh
    sh racket-minimal-6.6-x86_64-linux.sh --unix-style --create-dir --dest /usr/
fi

# force install the json-rpc-client racket package if there is no checkout on disk 
if [ ! -d json-rpc-client ]; then
    git clone https://github.com/vdloo/json-rpc-client &&\
    (cd json-rpc-client &&\
    raco pkg install --deps force)
fi

# create a kodictl checkout if the directory does not exist
if [ ! -d kodictl ]; then
    git clone https://github.com/vdloo/kodictl
fi

racket kodictl/main.rkt $@

