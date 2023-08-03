---
layout: default
title: Overriding user
parent: Using containers
permalink: /overriding-user/
nav_order: "040.040"
---

# Overriding user
{: .fs-9 }

and the group
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Container user and the group can be overridden *at the image build time* or *at the container creation time*.

{% include components/collapsible-toc.md %}

## At image build time

Building *accetto images* lies outside the scope of this *User guide*.
However, the container user and the group can be overridden also by [Extending images][this-extending-examples].

## At container creation time

Overriding the container user and the group is supported by the `docker run` command by default.

It can be used by providing the parameter `--user ID:GID` to the `docker run` command.
Providing the group ID (GID) is optional.

[Docker Docs][docker-docs-run-user]{: .btn .fs-2 }

However, there are some subtle differences between the *accetto containers* and the common Docker containers.

The *accetto containers* enhance the overriding support provided by Docker.

When you override the container user and optionally also the group, the *startup script* creates the related records in the system files `/etc/group` and `/etc/passwd` inside the container.
This makes a difference in some scenarios.

Additionally, the previous default container user and the group are renamed into `g3builder`.

{: .warning}
> Skipping the *startup script* by using the startup parameter `--skip-startup` will disable the enhanced support.
> Read about other consequences [here][this-pitfall-skipping-startup-script].

The following exercise illustrates the differences between the *accetto containers* and the common Docker containers.

### Exercise 1 (non-root)

{: .use_case}
> Let's override the user and the group by an *accetto container*.

Create the container using the following command:

```shell
docker run -it --rm --user 2000:3000 accetto/ubuntu-vnc-xfce-g3 bash
```

After the container is started, execute the commands shown in the following terminal window.

Stop the container by executing `exit` and then pressing `CTRL-c`.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@3d4f659c92e4:~$ id
> uid=2000(headless) gid=3000(headless) groups=3000(headless)
>
> headless@3d4f659c92e4:~$ tail -n2 /etc/passwd /etc/group
> ==> /etc/passwd <==
> g3builder:x:1000:1000:G3Builder:/home/headless:/bin/bash
> headless:x:2000:3000:Default:/home/headless:/bin/bash
>
> ==> /etc/group <==
> g3builder:x:1000:
> headless:x:3000:
>
> headless@3d4f659c92e4:~$ id g3builder
> uid=1000(g3builder) gid=1000(g3builder) groups=1000(g3builder)
>
> headless@3d4f659c92e4:~$ exit
> exit
> ^C
> </pre>

It can be seen that the new records have been indeed added into the files `/etc/passwd` and `/etc/group` inside the container.

Also the previous default container user and the group have been renamed into `g3builder`.

{: .use_case}
> Let's override the user and the group by a standard Ubuntu container.

Create the container using the following command:

```shell
docker run -it --rm --user 2000:3000 ubuntu
```

After the container is started, execute the commands shown in the following terminal window.

Stop the container by executing `exit`.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> groups: cannot find name for group ID 3000
>
> I have no name!@245977effb33:/$ id
> uid=2000 gid=3000 groups=3000
>
> I have no name!@245977effb33:/$ grep -E '2000|1000' /etc/passwd
> I have no name!@245977effb33:/$ grep -E '3000|1000' /etc/group
>
> I have no name!@245977effb33:/$ exit
> exit
> </pre>

It can be seen that the records for the user `2000:3000` have not been added into the system files inside the container.
Hence the prompt text beginning with `I have no name!`.

{: .use_case}
> Let's override the user and the group by an *accetto container*, bypassing its startup script.

Create the container using the following command:

```shell
docker run -it --rm --user 2000:3000 accetto/ubuntu-vnc-xfce-g3 --skip-startup bash
```

After the container is started, execute the commands shown in the following terminal window.

Stop the container by executing `exit`.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> groups: cannot find name for group ID 3000
>
> I have no name!@3b233ea4d91c:~$ id
> uid=2000 gid=3000 groups=3000
>
> I have no name!@3b233ea4d91c:~$ grep -E '2000|1000' /etc/passwd
> headless:x:1000:1000:Default:/home/headless:/bin/bash
>
> I have no name!@3b233ea4d91c:~$ grep -E '3000|1000' /etc/group
> headless:x:1000:
>
> I have no name!@3b233ea4d91c:~$ exit
> exit
> </pre>

It can be seen that the behavior is similar to the common Docker containers with the exception of the records in the system files `/etc/passwd` and `/etc/group` inside the container.
This is because these records are created by the Dockerfile when the image is built.

### Exercise 2 (root)

The particular case of overriding the container user and the group is overriding to the `root` user (`0:0`).

The `root` user (`0:0`) alway exists and therefore there is no problem with missing record in the system files `/etc/passwd` and `/etc/group` inside the container.

{: .highlight}
> In fact, the `root` (`0:0`) is the default container user of the common Docker containers.
>
> However, it's not the default container user of the *accetto containers*.
> These use the non-root user `headless` (`1000:1000`) instead.

{: .note}
> The `root` account *inside* the container is not the same as the one on the host computer and it does not get the same permissions on the host computer by default.

{: .note}
> Some applications may refuse to install or to run under the `root` account.

{: .note}
> The `Docker Desktop for Linux` always maps the container user to the `root` account, which has some odd consequences. Read more about it [here][this-pitfall-docker-desktop-for-linux-changing-ownership].

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/container-user/
[this-goto-next-page]: {{site.baseurl}}/overriding-envv/

[this-extending-examples]: {{site.baseurl}}/using-compose/extending-examples/

[this-pitfall-docker-desktop-for-linux-changing-ownership]: {{site.baseurl}}/using-bind-mounts/#pitfall-docker-desktop-for-linux-changing-ownership

[this-pitfall-skipping-startup-script]: {{site.baseurl}}/container-startup/#pitfall-skipping-startup-script

[docker-docs-run-user]: https://docs.docker.com/engine/reference/run/#user
