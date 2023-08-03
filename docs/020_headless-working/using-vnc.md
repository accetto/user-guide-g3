---
layout: default
title: Using VNC viewer
parent: Headless working
permalink: /using-vnc/
nav_order: "020.20"
---

# Headless working
{: .fs-9 }

using VNC viewer
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
The *VNC server* runs *inside* the container and listens on the TCP port `5901` by default.
The port is exposed to the outside world according the *port bindings* defined by creating the container.

{% include components/collapsible-toc.md %}

You can access the container over the network using a *VNC viewer*, regardless where the container is running - locally on your host computer or on a remote system.

You will need to install some of the VNC viewers, freely available on the Internet (e.g. [TigerVNC][tigervnc]), on your local host computer.

The main parameters of the *VNC server* are defined by the environment variables *inside* the container.
However, there are several ways to [override][this-overriding-vnc] them.

The default values of the main VNC parameters are:

- `VNC_PORT=5901`
- `VNC_PW=headless`
- `VNC_RESOLUTION=1360x768`
- `VNC_COL_DEPTH=24`
- `VNC_VIEW_ONLY=false`
- `DISPLAY=:1`

{: .explain}
> `VNC_PORT`: VNC server *inside* the container listens on the TCP port 5901.
>
> `VNC_PW`: Password for the VNC connection is 'headless'.
>
> `VNC_RESOLUTION`: Display resolution *inside* the container is 1360x768 pixels.
>
> `VNC_COL_DEPTH`: Color depth of 24 bit.
>
> `VNC_VIEW_ONLY`: VNC session is not *view-only*.
>
> `DISPLAY`: VNC server *inside* the container uses the display number ':1'.
> This parameter is important only in advanced scenarios.

The VNC port `5901` of the container is usually not bound to the same port on the host system.
Although it's possible, it may not work correctly.
The port `5901` must be bound to a *free* TCP port on the host.

You can find or guess some free TCP port yourself or you can let the Docker to do it for you by providing the parameters `-P` or `-p :5901` to the `docker run` command.

{: .important}
> You should be aware, that the TCP port binding happens at the moment of creating the container and that it stays permanent for its whole life.
> If you want to change it, you have to re-create the container.

{: .note}
> Please do not confuse the *container user password* with the *VNC connection password*.
> These are two different passwords, even if they both have the same default value of 'headless'.

## Exercise

{: .use_case}
> Let's say that you want to create a container, that *will not* keep running in the background, but removes itself after the exercise is completed.
> You want to access the container using a VNC viewer on the TCP port `35901`.

{: .note}
> The TCP ports in this range are usually free, but it can happen, that the port `35901` is not.
> Then you need to use some other free TCP port.

Open a new terminal window on your host and execute the following command:

```shell
docker run --rm -p "35901:5901" accetto/ubuntu-vnc-xfce-g3
```

{: .explain}
> Parameter `--rm` causes the automatic container removal after it is stopped.
>
> Parameter `-p "35901:5901"` binds the TCP port `5901` of the container to the TCP port `35901` of the host computer.
>
> Note that the container is running in the default foreground mode because the parameter `-d` (detached) has not been provided.

Now you can start your VNC viewer and point it to the TCP port `35901`.

If you use, for example, the `TigerVNC Viewer`, then you'll get the following two dialog windows.

Input `:35901` as the VNC server address and `headless` as the VNC password.

![vnc viewer connect][this-animation-tigervnc-viewer-connect]

{: .explain}
> The VNC address `:35901` begins with the colon because the IP address part has been omitted.
> The full form would be `0.0.0.0:35901`, because the port binding has happened on all network interfaces of the host computer.
> See [Running containers][this-running-containers] for more information.
>
> The warning `This connection is not secure` means that the VNC traffic will not be encrypted.
> This is currently the only mode supported by the containers.

The VNC viewer window should open and you should see the container's desktop.

You can resize the VNC viewer window and test the container by double-clicking the `Version Sticker` launcher on the desktop.

![animation-open-version-sticker][this-animation-open-version-sticker]

After testing you can close the VNC viewer's window and stop the running container by pressing `CTRL-c` in the terminal window that you've used for starting the container.
The container will remove itself automatically.

{: .note}
> Closing the VNC viewer's window alone does not stop the running container, it only disconnects from it.
> You can connect to a running container as many times as you wish.

For the real *headless working* you would run the container [detached][this-running-detached] in the background.

Learn more about [Running containers][this-running-containers].

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/using-novnc/
[this-goto-next-page]: {{site.baseurl}}/running-containers/

[this-overriding-vnc]: {{site.baseurl}}/overriding-vnc/
[this-running-containers]: {{site.baseurl}}/running-containers/
[this-running-detached]: {{site.baseurl}}/running-detached/

[this-animation-tigervnc-viewer-connect]: {{site.baseurl}}/assets/images/tigervnc-viewer-connect.gif
[this-animation-open-version-sticker]: {{site.baseurl}}/assets/images/animation-open-version-sticker.gif

[this-image-ubuntu-vnc-xfce-g3]: {{site.baseurl}}/assets/images/ubuntu-vnc-xfce-g3.png

[accetto-github]: https://github.com/accetto
[accetto-dockerhub]: https://hub.docker.com/u/accetto/

[novnc]: https://github.com/novnc/noVNC
[tigervnc]: http://tigervnc.org
