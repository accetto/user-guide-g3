---
layout: default
title: Detached
parent: Running containers
permalink: /running-detached/
nav_order: "030.10"
---

# Detached containers
{: .fs-9 }

running in the background
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Running detached in the background means, that after the container has been created, it keeps running in the computer's memory, but no console is attached to it.
However, it listens on certain ports, if it's designed that way.

[Docker Docs: Docker run reference][docker-docs-run-reference]{: .btn .fs-2 }

{: .highlight}
This is the *intended default mode* of *accetto containers*, but not the default mode of the `docker run` command.
Therefore you have to use the parameter `-d` by creating detached containers.

{% include components/collapsible-toc.md %}

## Exercise 1

{: .use_case}
> Let's say that you want to create a new randomly named container, that will keep running detached in the background and listen on the automatically selected TCP ports of the host computer.
> You want to bind all ports that container exposes.

You can create the container using the following command:

```shell
docker run -d -P accetto/ubuntu-vnc-xfce-g3
```
After the image is pulled from Docker Hub and the container created, you can verify the result from a terminal window on your host computer.

Because all *accetto containers* expose at least the VNC and noVNC ports, the following command

```shell
{% raw %}docker ps --format 'table {{.Names}}\t{{.Ports}}'{% endraw %}
```

will output something like this

{% include components/callout-terminal.md %}
> <pre>
> NAMES                    PORTS
> tender_wright            0.0.0.0:32771->5901/tcp, 0.0.0.0:32770->6901/tcp
> </pre>

{: .explain}
> The parameter `-d` causes the container to run detached in the background.
>
> The parameter `-P` binds all TCP ports exposed by the container to some free TCP ports on the host.
> It happens on all network interfaces of the host (IP address `0.0.0.0`).
>
> The value `tender_wright` is the random container name assigned by Docker CLI.
>
> The part `0.0.0.0:32771->5901/tcp` means that the TCP port 5901 (VNC) from the container is bound to the TCP port 32771 on all network interfaces of the host computer.
>
> You can connect to the container by navigating your VNC viewer to the address `127.0.0.1:32771`.
> Instead of the IP address `127.0.0.1` you can use any accessible IP address of your host computer.
> You can also use `:32771` or `0.0.0.0:32771`.
>
> The part `0.0.0.0:32770->6901/tcp` means that the TCP port 6901 (noVNC) from the container is bound to the TCP port 32770 on all network interfaces of the host computer.
>
> You can connect to the container by navigating your web browser to the address `http://127.0.0.1:32770`.
> Instead of the IP address `127.0.0.1` you can use any accessible IP address of your host computer.

{: .note}
> It is not recommended to bound the VNC/noVNC ports (5901/6901) of the container to the same TCP ports of the host computer.
> Even if it's possible, it may not work correctly.
> If you don't like using fixed port bindings, you can let Docker CLI to choose some free TCP ports automatically.
> Use the parameters `-P` or `-p :5901 -p :6901` for that.

You can remove the container using the following command:

```shell
docker rm -f tender_wright
```

## Exercise 2

{: .use_case}
> Let's say that you want to create a detached container and to name it `devrun`.
> You want to allow the VNC viewer access only from the host computer, but the web browser access also from elsewhere.

You can create the container using the following command:

```shell
docker run -d --name devrun --hostname devrun -p "127.0.0.1:32771:5901" -p "32770:6901" accetto/ubuntu-vnc-xfce-g3
```

After the image is pulled from Docker Hub and the container created, you can verify the result from a terminal window on your host computer.

The output from following command:

```shell
{% raw %}docker ps --format 'table {{.Names}}\t{{.Ports}}'{% endraw %}
```
should look like this:

{% include components/callout-terminal.md %}
> <pre>
> NAMES                    PORTS
> devrun                   127.0.0.1:32771->5901/tcp, 0.0.0.0:32770->6901/tcp
> </pre>

{: .explain}
> The parameter `-d` causes the container tu run detached in the background.
> 
> The parameter `--name devrun` sets the container name to 'devrun'.
> The parameter `--hostname devrun` sets the host name inside the container to the same value.
> This parameter is not strictly necessary if you are happy with the automatically generated host name.
>
> The parameter `-p "127.0.0.1:32771:5901"` binds the VNC port 5901 of the container to the TCP port 32771 of the host computer,
> but only on its `localhost` IP address `127.0.0.1`.
> Therefore is the VNC viewer access allowed only from the host computer itself.
>
> The parameter `-p "32770:6901"` binds the noVNC port 6901 of the container to the TCP port 32770 of the host computer.
> It does it on all network interfaces of the host computer (IP address `0.0.0.0`) and therefore is the web browser access allowed also from elsewhere.

You can check the port binding using the following command:

```shell
docker container port devrun
```

{% include components/callout-terminal.md %}
> <pre>
> 5901/tcp -> 127.0.0.1:32771
> 6901/tcp -> 0.0.0.0:32770
> </pre>

You can remove the container using the following command:

```shell
docker rm -f devrun
```

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/running-containers/
[this-goto-next-page]: {{site.baseurl}}/running-interactively/

[accetto-github]: https://github.com/accetto
[accetto-dockerhub]: https://hub.docker.com/u/accetto/

[docker-docs-run-reference]: https://docs.docker.com/engine/reference/run/
