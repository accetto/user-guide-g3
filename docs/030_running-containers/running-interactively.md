---
layout: default
title: Interactively
parent: Running containers
permalink: /running-interactively/
nav_order: "030.20"
---

# Interactive containers
{: .fs-9 }

running in the foreground
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Running in the foreground means, that after the container has been created, it keeps running only until its task process is not completed.
Console is often also attached to such containers.

[Docker Docs: Docker run reference][docker-docs-run-reference]{: .btn .fs-2 }

{: .highlight}
This is the *default mode* of the `docker run` command.

{% include components/collapsible-toc.md %}

The containers running in the foreground are most often used in the following common scenarios.

#### Interactive session
{: .no_toc}

<!-- {: .use_case} -->
> A process is started in the container (e.g. `bash`) and the console is attached to it.
> The container keeps running until the process exits.
> As long as the standard input stream `STDIN` stays opened, you can work interactively inside the container from the console of your host computer.

{: .note}
> Because all *accetto containers* include Xfce desktop environment, you don't need to run them in the foreground mode to be able to work with them interactively.

#### One-time task
{: .no_toc }

<!-- {: .use_case} -->
> Container gets a task (e.g. some script), executes it and then exits.

Note that the container is not automatically removed, unless you ask for it explicitly by providing the parameter `--rm` to the `docker run` command.

{: .important}
> The *accetto containers* are not intended for this scenario.
> It's certainly possible to use them also this way, but sometimes it may be not so straightforward as expected (see the exercises below).
> However, you can always start an interactive session and execute the task that way.

## Exercise 1

{: .use_case}
> Let's say that you want to create a randomly named temporary container for working inside it interactively with `bash`. The container should be automatically removed after it's stopped.

You can create the container using the following command:

```shell
docker run -it --rm accetto/ubuntu-vnc-xfce-g3 --skip-vnc bash
```

{: .explain}
> The parameter `-it` attaches the host computer console to the container and keeps the standard input stream opened.
> It allows working inside the container interactively.
>
> The parameter `--rm` ensures that the container is automatically removed after it is stopped.

After the image is pulled from Docker Hub and the container created, you can work inside it interactively until you exit the bash `session` by entering `exit` and then stop the container by pressing `CTRL-c`.

{% include components/callout-terminal.md %}
> <pre>
> headless@7cb955144aeb:~$ id
> uid=1000(headless) gid=1000(headless) groups=1000(headless)
> headless@7cb955144aeb:~$ exit
> exit
> ^C
> </pre>

Note that the whole graphical desktop subsystem is not used in this scenario and also the VNC server and noVNC client are not started.
The container behaves as a basic `Ubuntu` container extended by some additional utilities.

However, if you would use the following command

```shell
docker run -it -P --rm accetto/ubuntu-vnc-xfce-g3 bash
```

then you would be able to connect to the running interactive container using a VNC viewer or a web browser until you stop it.

{: .explain}
> The parameter `-it` attaches the host computer console to the container and keeps the standard input stream opened.
> It allows working inside the container interactively.
>
> The parameter `-P` binds all TCP ports exposed by the container to automatically selected free TCP ports of the host computer.
>
> The parameter `--rm` ensures that the container is automatically removed after it is stopped.

While the interactive container is running, you can find out its name and ports by executing the following command in an *another* terminal on your host computer:

```shell
{% raw %}docker ps --format 'table {{.Names}}\t{{.Ports}}'{% endraw %}
```

The output for the first case should look similar to this

{% include components/callout-terminal.md %}
> <pre>
NAMES                    PORTS
adoring_robinson         5901/tcp, 6901/tcp
> </pre>

or for the second case similar to this

{% include components/callout-terminal.md %}
> <pre>
NAMES                    PORTS
adoring_robinson         0.0.0.0:32771->5901/tcp, 0.0.0.0:32770->6901/tcp
> </pre>

{: .explain}
> The value `adoring_robinson` is the random container name assigned by Docker CLI.
>
> The part `5901/tcp, 6901/tcp` shows, that the container still exposes the `VNC/noVNC` ports (`5901/6901`), but they are not bound to any TCP ports of the host computer. Actually, the the VNC/noVNC servers inside the container have not been even started.
> See the [startup help][this-startup-help] for more information.
>
> The part `0.0.0.0:32771->5901/tcp, 0.0.0.0:32770->6901/tcp` shows that the `VNC/noVNC` ports (`5901/6901`) have been bound to the ports `32771/32770` of the host computer.

## Exercise 2

{: .use_case}
> Let's say that you want to execute a one-time task in a temporary container, that will be automatically removed after the task is completed.

{: .important}
> Because of the startup script specifics, the container will not automatically stop after the task is completed unless you use the startup option `--skip-startup`.
> If you don't, you'll need to stop the container by pressing `CTRL-c`.

The following command creates a new container and lists the content of its `/home/headless` directory.
The container will be automatically removed afterwards.

```shell
docker run --rm accetto/ubuntu-vnc-xfce-g3 --skip-startup ls -l /home/headless
```

{: .explain}
> The parameter `--rm` ensures that the container is removed after it is stopped.
>
> The parameter `--skip-startup` is specific to *accetto containers* and if it's not provided, then the container must be stopped by pressing `CTRL-c`.
>
> The text `ls -l //home/headless` is the command to execute inside the container.

The command output should look like this:

{% include components/callout-terminal.md %}
> <pre>
> total 12
> drwxr-xr-x 1 root root 4096 Desktop
> -rw-r--r-- 1 root root  185 readme.md
> drwxr-xr-x 1 root root 4096 tests
> </pre>

{: .important}
> You can see from the console output, that the container user's home directory is not completely initialized.
> It is the consequence of using the startup option `--skip-startup`.
> This [page][this-pitfall-skipping-startup-script] explains why skipping the startup script could be a pitfall.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/running-detached/
[this-goto-next-page]: {{site.baseurl}}/using-containers/

[this-startup-help]: {{site.baseurl}}/startup-help/

[this-pitfall-skipping-startup-script]: {{site.baseurl}}/container-startup/#pitfall-skipping-startup-script

[accetto-github]: https://github.com/accetto
[accetto-dockerhub]: https://hub.docker.com/u/accetto/

[docker-docs-run-reference]: https://docs.docker.com/engine/reference/run/
