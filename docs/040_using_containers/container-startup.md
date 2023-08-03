---
layout: default
title: Container startup
parent: Using containers
permalink: /container-startup/
nav_order: "040.010"
---

# Container startup
{: .fs-9 }

and initialization
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Container user account, container user group and container environment are finalized by the startup script on the first container start.

{% include components/collapsible-toc.md %}

## First container start

The *container startup script* modifies the container's files `/etc/passwd` and `/etc/group` during the *very first container start*.

Because the modification requires elevated permissions, the script needs the initial `sudo` password, which is therefore temporarily stored into the file `$STARTUPDIR/.initial_sudo_password`.

The startup script then performs the following tasks:

- it creates the container user's `user group` (in `/etc/group`)
- it creates the container user's `user account` (in `/etc/passwd`)
- it sets the created container user as the owner of the following folders including their content
  - container startup folder (`$STARTUPDIR`)
  - user home folder (`$HOME`)

After completing these tasks it removes the initial sudo password from the file `$STARTUPDIR/.initial_sudo_password`.

{: .warning}
> The initial `sudo` password will still be persisted in the Docker image history.
> You have to change the password *inside* the container, if you want to keep it really secret.

The created container user is a *non-root* user and its account has only the permissions of a standard user.

However, the container user account is also added into the `sudo` user group and therefore it can get also elevated permissions on request.

{: .important}
> The default container user password and the `sudo` password is `headless`.

## Test 01

All *accetto containers* include the test script `$HOME/tests/test-01.sh`, which allows to quickly check the container configuration.

You can execute the test also as a one-time task using the following command.

```shell
docker run --rm accetto/ubuntu-vnc-xfce-g3 /home/headless//tests/test-01.sh
```

After checking the output, exit the container by pressing `CTRL-c`.

The output should look like this:

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> + id
> uid=1000(headless) gid=1000(headless) groups=1000(headless)
> + ls -l /etc/passwd /etc/group
> -rw-r--r-- 1 root root  481 /etc/group
> -rw-r--r-- 1 root root 1029 /etc/passwd
> + tail -n2 /etc/passwd
> messagebus:x:101:101::/nonexistent:/usr/sbin/nologin
> headless:x:1000:1000:Default:/home/headless:/bin/bash
> + tail -n2 /etc/group
> messagebus:x:101:
> headless:x:1000:
> + ls -ld /dockerstartup /home /home/headless
> drwxr-xr-x 1 headless headless 4096 /dockerstartup
> drwxr-xr-x 1 root     root     4096 /home
> drwxr-xr-x 1 headless headless 4096 /home/headless
> + ls -l /dockerstartup
> total 48
> -rw-r--r-- 1 headless headless 3090 help.rc
> -rw-r--r-- 1 headless headless    0 novnc.log
> -rw-r--r-- 1 headless headless 6721 parser.rc
> -rwxr--r-- 1 headless headless  872 set_user_permissions.sh
> -rwxr-xr-x 1 headless headless 4778 startup.sh
> -rw-r--r-- 1 headless headless 4010 user_generator.rc
> -rwxr--r-- 1 headless headless 5216 version_of.sh
> -rwxr--r-- 1 headless headless 3336 version_sticker.sh
> -rw-r--r-- 1 headless headless    0 vnc.log
> -rw-r--r-- 1 headless headless 4958 vnc_startup.rc
> + mkdir -p /home/headless/new-dir
> + touch /home/headless/new-file
> + ls -l /home/headless
> total 28
> drwxr-xr-x 1 headless headless 4096 Desktop
> drwxr-xr-x 2 headless headless 4096 new-dir
> -rw-r--r-- 1 headless headless    0 new-file
> -rw-r--r-- 1 headless headless  185 readme.md
> -rw-r--r-- 1 headless headless 1364 test-01.log
> drwxr-xr-x 1 headless headless 4096 tests
> </pre>
> ^C

## Verbose and Debug modes

There are two startup options, that allow you to get more information about the container startup.

### Verbose mode
{: .no_toc}

The `--verbose` option causes an output similar to the following one.
The same output goes also into the container's log.
Stop the container by pressing `CTRL-c`.

```shell
docker run --rm accetto/ubuntu-vnc-xfce-g3 --verbose
```

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> Container '7fefc950da47' started
> Starting VNC
> vncserver :1 &> /dockerstartup/vnc.log
> VNC server started on display ':1' and TCP port '5901'
> Connect via VNC viewer with 172.17.0.2:5901
> Starting noVNC
> /usr/libexec/noVNCdim/utils/novnc_proxy --vnc localhost:5901 --listen 6901  &> /dockerstartup/novnc.log
> noVNC started on TCP port '6901'
> Connect via web browser
> ^CKilling last background PID '32'
> Killing blocking PID '31'
> </pre>

### Debug mode
{: .no_toc}

The `--debug` option outputs more information.
The same output goes also into the container's log.
Stop the container by pressing `CTRL-c`.

```shell
docker run --rm accetto/ubuntu-vnc-xfce-g3 --debug
```

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> Container 'dfcf3e0443a0' started
> Script: /dockerstartup/startup.sh
> ${HOME}=/home/headless
> ls -la /
> total 60
> drwxr-xr-x   1 root root 4096 .
> drwxr-xr-x   1 root root 4096 ..
> -rwxr-xr-x   1 root root    0 .dockerenv
> lrwxrwxrwx   1 root root    7 bin -> usr/bin
> drwxr-xr-x   2 root root 4096 boot
> drwxr-xr-x   5 root root  340 dev
> drwxr-xr-x   1 root root 4096 dockerstartup
> drwxrwxr-x   1  984  980 4096 etc
> drwxr-xr-x   1 root root 4096 home
> lrwxrwxrwx   1 root root    7 lib -> usr/lib
> lrwxrwxrwx   1 root root    9 lib32 -> usr/lib32
> lrwxrwxrwx   1 root root    9 lib64 -> usr/lib64
> lrwxrwxrwx   1 root root   10 libx32 -> usr/libx32
> drwxr-xr-x   2 root root 4096 media
> drwxr-xr-x   2 root root 4096 mnt
> drwxr-xr-x   2 root root 4096 opt
> dr-xr-xr-x 326 root root    0 proc
> drwx------   2 root root 4096 root
> drwxr-xr-x   5 root root 4096 run
> lrwxrwxrwx   1 root root    8 sbin -> usr/sbin
> drwxr-xr-x   2 root root 4096 srv
> dr-xr-xr-x  13 root root    0 sys
> drwxrwxrwt   1 root root 4096 tmp
> drwxrwxr-x   1  984  980 4096 usr
> drwxr-xr-x   1 root root 4096 var
> ls -ls /etc/passwd /etc/group
> 4 -rw-rw-rw- 1 root root  481 /etc/group
> 4 -rw-rw-rw- 1 root root 1029 /etc/passwd
> ls -la /home
> total 12
> drwxr-xr-x 1 root root 4096 .
> drwxr-xr-x 1 root root 4096 ..
> drwxr-xr-x 1 root root 4096 headless
> ls -la /home/headless
> total 24
> drwxr-xr-x 1 root root 4096 .
> drwxr-xr-x 1 root root 4096 ..
> drwxr-xr-x 1 root root 4096 .config
> drwxr-xr-x 1 root root 4096 Desktop
> -rw-r--r-- 1 root root  185 readme.md
> drwxr-xr-x 1 root root 4096 tests
> ls -la .
> total 24
> drwxr-xr-x 1 root root 4096 .
> drwxr-xr-x 1 root root 4096 ..
> drwxr-xr-x 1 root root 4096 .config
> drwxr-xr-x 1 root root 4096 Desktop
> -rw-r--r-- 1 root root  185 readme.md
> drwxr-xr-x 1 root root 4096 tests
> Starting VNC
> vncserver :1 &> /dockerstartup/vnc.log
> VNC server started on display ':1' and TCP port '5901'
> Connect via VNC viewer with 172.17.0.2:5901
> Starting noVNC
> /usr/libexec/noVNCdim/utils/novnc_proxy --vnc localhost:5901 --listen 6901  &> /dockerstartup/novnc.log
> noVNC started on TCP port '6901' 
> Connect via web browser
> ^CKilling last background PID '36'
> Killing blocking PID '35'
> </pre>

## Pitfall `Skipping startup script`

{: .pitfall}
> <span class="text-delta">
> Skipping startup script
> <br/>
> </span>
> The container environment will be *fully configured* only if the related part of the container's *startup script* will be successfully executed.

{: .important}
> There is also a similar pitfall, which is related to extending images.
> Read about it [here][this-pitfall-extending-images-and-failing-startup].
>
> The consequences by overriding the container user are described [here][this-overriding-user].

Compare the following example to the one from above:

```shell
docker run --rm accetto/ubuntu-vnc-xfce-g3 --skip-startup /home/headless/tests/test-01.sh
```

In this case you'll get the following output:

{% include components/callout-terminal.md %}
> /dockerstartup/startup.sh: line 55: /home/headless//tests/test-01.sh: Permission denied

{: .explain}
> The reason is, that the ownership of the container user's home directory and its content has not been correctly set, because the startup script has been skipped.
> It has been caused by using the startup parameter `--skip-startup`.

However, you can still use the container if you have sufficient Linux knowledge.
For example, you can correct the permissions problem manually or you can perform tasks that are not affected by it.

You can further investigate the incomplete container environment configuration.

For example, you can create an interactive container using the following command:

```shell
docker run --rm -it accetto/ubuntu-vnc-xfce-g3 --skip-startup bash
```

Then you can perform the following tests:

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@b705485bdb36:~$ id
> uid=1000(headless) gid=1000(headless) groups=1000(headless)
>
> headless@b705485bdb36:~$ cat /etc/passwd | grep headless
> headless:x:1000:1000:Default:/home/headless:/bin/bash
>
headless@b705485bdb36:~$ cat /etc/group | grep headless
headless:x:1000:
> </pre>

You can see, that the container user account and the group have been correctly configured.

You can found out the reason, why the previously mentioned `test-01.sh` has failed by executing the following:

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@b705485bdb36:~$ ls -l
> total 12
> drwxr-xr-x 1 root root 4096 Desktop
> -rw-r--r-- 1 root root  185 readme.md
> drwxr-xr-x 1 root root 4096 tests
> </pre>

You can see that the content of the `$HOME` directory is owned by the `root` user, not the user `1000`.

You can compare this incompletely initialized configuration to the complete one from above:

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@b705485bdb36:~$ sudo tests/test-01.sh 
> [sudo] password for headless: 
> + id
> uid=0(root) gid=0(root) groups=0(root)
> + ls -l /etc/passwd /etc/group
> -rw-rw-rw- 1 root root  464 /etc/group
> -rw-rw-rw- 1 root root 1029 /etc/passwd
> + tail -n2 /etc/passwd
> messagebus:x:101:101::/nonexistent:/usr/sbin/nologin
> headless:x:1000:1000:Default:/home/headless:/bin/bash
> + tail -n2 /etc/group
> messagebus:x:101:
> headless:x:1000:
> + ls -ld  /home /root
> drwxr-xr-x 1 root root 4096 /home
> drwx------ 2 root root 4096 /root
> + ls -l 
> total 16
> drwxr-xr-x 1 root root 4096 Desktop
> -rw-r--r-- 1 root root  185 readme.md
> -rw-r--r-- 1 root root  492 test-01.log
> drwxr-xr-x 1 root root 4096 tests
> + mkdir -p /root/new-dir
> + touch /root/new-file
> + ls -l /root
> total 4
> drwxr-xr-x 2 root root 4096 new-dir
> -rw-r--r-- 1 root root    0 new-file
> </pre>

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/using-containers/
[this-goto-next-page]: {{site.baseurl}}/startup-help/

[this-startup-help]: {{site.baseurl}}/startup-help/

[this-overriding-user]: {{site.baseurl}}/overriding-user/

[this-pitfall-extending-images-and-failing-startup]: {{site.baseurl}}/using-compose/extending-examples/#pitfall-extending-images-and-failing-startup
