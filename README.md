raptiformica-notify-kodi
========================

Send GUI notifications to a [Kodi](https://github.com/xbmc/xbmc) instance when [raptiformica](http://github.com/vdloo/raptiformica) hooks are triggered. 

This is a raptiformica plugin that displays messages on Kodi when machines leave or join the cluster or when other configured events are triggered. Basically this is a quick and dirty shell wrapper around [kodictl](https://github.com/vdloo/kodictl) that 1. installs Racket 6.6 if no Racket is installed 2. installs [this Racket json-rpc-client](https://github.com/vdloo/json-rpc-client) as a raco package and 3. creates a checkout of kodictl which is then called with the `notify` option. You probably do not want to use this if you weren't planning on already using Racket on your systems. This contraption is very heavyweight because the required disk-space for this installation of Racket 6.6 is around 10M which is a lot when considering that the functionality of this plugin could be replaced with a simple curl to the Kodi json-rpc.

Also this method of installing Racket and raco packages is not how you are supposed to do it if you want to do it the right way but since I'm just running this in dockers and I just wanted to cook up something fast to accomplish the goal of displaying messages from the system on my TV I chose to duct-tape this together as a solution.

## Installation

To install the module
```
raptiformica modprobe vdloo/raptiformica-notify-kodi
```

If your Kodi host is not in the raptiformica network you might want to configure the kodictl command to use a different endpoint than localhost. Note that each host in the network will then send a message to the same Kodi instance.  

```
# edit the lazy_kodictl.sh wrapper
vim ~/.raptiformica.d/modules/raptiformica-notify-kodi/lazy_kodictl_notification.sh
# change this:
racket kodictl/kodictl/main.rkt notify "raptiformica `hostname`" "$@"
# to something like this:
racket kodictl/kodictl/main.rkt -r http://192.168.1.2:8080/jsonrpc notify "raptiformica `hostname`" "$@"
```
