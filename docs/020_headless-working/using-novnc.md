---
layout: default
title: Using web browser
parent: Headless working
permalink: /using-novnc/
nav_order: "020.10"
---

# Headless working
{: .fs-9 }

using web browser
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
The *noVNC client* application runs *inside* the container and listens on the TCP port `6901` by default.
The port is exposed to the outside world according the *port bindings* defined by creating the container.

{% include components/collapsible-toc.md %}

You can access the running container over the network using a web browser, regardless where the container is running - locally on your host computer or on a remote system.

The *noVNC client* forwards all requests to the *VNC server* running *inside* the container, therefore it shares most of the configuration parameters with it:

- `VNC_PW=headless`
- `VNC_RESOLUTION=1360x768`
- `VNC_COL_DEPTH=24`
- `VNC_VIEW_ONLY=false`
- `DISPLAY=:1`

The *VNC parameters* are explained [here][this-using-vnc].

There are also two parameters specific to *noVNC client*:

- `NOVNC_PORT=6901`
- `NOVNC_HEARTBEAT`

{: .explain}
> `NOVNC_PORT`: The noVNC client *inside* the container listens on the TCP port '6901'.
>
> The default password for the noVNC connection is `headless`.
>
> `NOVNC_HEARTBEAT`: The parameter `NOVNC_HEARTBEAT` is only for advanced scenarios and it has no default value.
> It's explained in the section [Overriding VNC][this-overriding-vnc].

The noVNC port `6901` of the container is usually not bound to the same port on the host system.
Although it's possible, it may not work correctly.
The port `6901` must be bound to a *free* TCP port on the host.

You can find or guess some free TCP port yourself or you can let the Docker to do it for you by providing the parameters `-P` or `-p :6901` to the `docker run` command.

{: .important}
> You should be aware, that the TCP port binding happens at the moment of creating the container and that it stays permanent for its whole life.
> If you want to change it, you have to re-create the container.

{: .note}
> Please do not confuse the *container user password* with the *noVNC connection password*.
> These are two different passwords, even if they both have the same default value of 'headless'.

## Exercise

{: .use_case}
> Let's say that you want to create a container, that *will not* keep running in the background, but removes itself after the exercise is completed.
> You want to access the container using a web browser on the TCP port `36901`.

{: .note}
> The TCP ports in this range are usually free, but it can happen, that the port `36901` is not.
> Then you need to use some other free TCP port.

Open a new terminal window on your host and execute the following command:

```shell
docker run --rm -p "36901:6901" accetto/ubuntu-vnc-xfce-g3
```

{: .explain}
> Parameter `--rm` causes the automatic container removal after it is stopped.
>
> Parameter `-p "36901:5901"` binds the noTCP port `6901` of the container to the TCP port `36901` of the host computer.
>
> Note that the container is running in the default foreground mode because the parameter `-d` (detached) has not been provided.

Assuming that you've created the container on your local host computer, you can access it by navigating your web browser to the following URL:

```html
http://localhost:36901
```

All *accetto containers* actually include two noVNC clients - the **lite** one and the **full** one.

The container displays a simple starting page containing the links to each client:

- noVNC Lite Client (`http://localhost:36901/vnc_lite.html`)
- noVNC Full Client (`http://localhost:36901/vnc.html`)

It is also possible to provide the connection password through the links.

For example:

- `http://localhost:36901/vnc_lite.html?password=headless`
- `http://localhost:36901/vnc.html?password=headless`

The following animations illustrates the connection process.
Input 'headless' as the password in both cases.

#### Lite client
{: .no_toc}

![novnc-lite connect][this-animation-novnc-lite-connect]

#### Full client
{: .no_toc}

![novnc-full connect][this-animation-novnc-full-connect]

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/headless-working/
[this-goto-next-page]: {{site.baseurl}}/using-vnc/

[this-using-vnc]: {{site.baseurl}}/using-vnc/

[this-overriding-vnc]: {{site.baseurl}}/overriding-vnc/

[this-animation-novnc-lite-connect]: {{site.baseurl}}/assets/images/novnc-lite-connect.gif

[this-animation-novnc-full-connect]: {{site.baseurl}}/assets/images/novnc-full-connect.gif
