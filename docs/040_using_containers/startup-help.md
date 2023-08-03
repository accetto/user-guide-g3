---
layout: default
title: Startup help
parent: Using containers
permalink: /startup-help/
nav_order: "040.020"
---

# Startup help
{: .fs-9 }

embedded into the images
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
All *accetto images* implement two different help pages.

{: .warning}
> By using the startup parameter `--skip-startup` you will skip the *startup script*, leaving the container environment *not completely configured*.
> You will need sufficient Linux knowledge to use such a container properly.
> Read more about this pitfall [here][this-pitfall-skipping-startup-script].

{% include components/collapsible-toc.md %}

## Startup script help

The following command will print out the *startup script help* and then it will exit and remove the container:

```shell
docker run --rm accetto/ubuntu-vnc-xfce-g3 --help
```

Console output:

```shell
Container startup script
Usage: /dockerstartup/startup.sh [-v|--version] [-h|--help] [-H|--help-usage]
[--(no-)wait] [--(no-)skip-startup] [--(no-)tail-null] [--(no-)tail-vnc]
[--(no-)version-sticker] [--(no-)version-sticker-verbose] [--(no-)skip-vnc] [--(no-)skip-novnc]
[--(no-)debug] [--(no-)verbose] [--] [<command-1>] ... [<command-n>] ...
    <command>: Optional command with optional arguments. It is executed during startup.
    -v, --version: Prints version
    -h, --help: Prints help
    -H, --help-usage: Extended container usage help.
    --wait, --no-wait: Default background execution mode (on by default)
    --skip-startup, --no-skip-startup: Default foreground execution mode (off by default)
    --tail-null, --no-tail-null: Alternative background execution mode (off by default)
    --tail-vnc, --no-tail-vnc: Alternative background execution mode (off by default)
    --version-sticker, --no-version-sticker: Alternative foreground execution mode (off by default)
    --version-sticker-verbose, --no-version-sticker-verbose: Alternative foreground execution mode (off by default)
    --skip-vnc, --no-skip-vnc: Startup process modifier (off by default)
    --skip-novnc, --no-skip-novnc: Startup process modifier (off by default)
    --debug, --no-debug: Startup process modifier (off by default)
    --verbose, --no-verbose: Startup process modifier (off by default)
Use '-H' or '--help-usage' for extended container usage help.
For more information visit https://github.com/accetto/ubuntu-vnc-xfce-g3
```

## Container usage help

The following command will print out the *container usage help* and then it will exit and remove the container:

```shell
docker run --rm accetto/ubuntu-vnc-xfce-g3:latest --help-usage
```

Console output:

```shell
CONTAINER USAGE:
docker run [<docker-run-options>] accetto/<image>:<tag> [<startup-options>] [<command>]

POSITIONAL ARGUMENTS:
command
    Optional command with optional arguments.
    It will be executed during startup before going waiting, tailing or asleep.
    It is necessary to use the quotes correctly or the 'bash -c "<command>"' pattern.

STARTUP OPTIONS:

--wait, or no options, or unknown option, or empty input
    Default background execution mode.
    Starts the VNC and noVNC servers, if available, then executes the command
    and waits until the VNC server process exits or goes asleep infinitely.
    Container keeps running in the background.

--skip-startup
    Default foreground execution mode.
    Skips the startup procedure, executes the command and exits.
    Be aware that the container user generator will be also skipped.
    Container does not keep running in the background.

--tail-null
    Alternative background execution mode.
    Similar to '--wait', but tails the null device instead of going asleep.
    Container keeps running in the background.

--tail-vnc
    Alternative background execution mode.
    Similar to '--wait', but tails the VNC log instead of waiting until the VNC process exits.
    Falls back to '--tail-null' if the VNC server has not been started.
    Container keeps running in the background.

--version-sticker
    Alternative foreground execution mode.
    Prints out the version sticker info.
    The VNC server is also started by default, if available, because some applications
    need a display to report their versions correctly. It can be suppressed by providing
    also '--skip-vnc'. The '--skip-novnc' option is always enforced automatically.
    Container does not keep running in the background.

--version-sticker-verbose
    Alternative foreground execution mode.
    Similar to '--version-sticker', but prints out the verbose version sticker info and features list.
    Container does not keep running in the background.

--skip-vnc
    Startup process modifier.
    If VNC and noVNC startup should be skipped.
    It also enforces '--skip-novnc'.

--skip-novnc
    Startup process modifier.
    If noVNC startup should be skipped.
    It is also enforced by '--skip-vnc'.

--debug
    Startup process modifier.
    If additional debugging info should be displayed during startup.
    It also enforces option '--verbose'.

--verbose
    Startup process modifier.
    If startup progress messages should be displayed.
    It is also enforced by '--debug'.

--help-usage, -H
    Prints out this extended container usage help and exits.
    The rest of the input is ignored.

--help, -h
    Prints out the short startup script help and exits.
    The rest of the input is ignored.

--version, -v
    Prints out the version of the startup script and exits.
    The rest of the input is ignored.

Use '-h' or '--help' for short startup script help.
Fore more information visit https://github.com/accetto/ubuntu-vnc-xfce-g3
```

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/container-startup/
[this-goto-next-page]: {{site.baseurl}}/container-user/

[this-pitfall-skipping-startup-script]: {{site.baseurl}}/container-startup/#pitfall-skipping-startup-script
