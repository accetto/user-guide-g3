---
layout: default
title: Overriding VNC
parent: Using containers
permalink: /overriding-vnc/
nav_order: "040.060"
---

# Overriding VNC
{: .fs-9 }

and noVNC parameters
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
The VNC/noVNC parameters are controlled by the related environment variables inside the container and can be overridden *at the image build time*, *at the container creation time* or *at the container startup time*.
The latter is a unique feature of *accetto containers*.

{: .note}
> Overriding VNC/noVNC parameters is only a particular case of [Overriding environment variables][this-overriding-envv].

{: .warning}
> Incorrectly overriding the VNC parameters can have severe consequences and can prevent the container from starting.
> Don't miss the [Important remarks][this-overriding-vnc-important-remarks] below.

{% include components/collapsible-toc.md %}

## At image build time

Building *accetto images* lies outside the scope of this *User guide*.
However, the container environment variables can be overridden also by [Extending images][this-extending-examples].

Environment variable values set during the image build time become part of the image and they cannot be changed afterwards, only overridden.
They are inherited by each container created from the image.

The VNC/noVNC parameters have the following default values:

- `VNC_PORT=5901`
- `NOVNC_PORT=6901`
- `VNC_PW=headless`
- `VNC_RESOLUTION=1360x768`
- `VNC_COL_DEPTH=24`
- `VNC_VIEW_ONLY=false`
- `DISPLAY=:1`
- `NOVNC_HEARTBEAT`

{: .explain}
> The VNC server listens on the *container's* TCP port `5901` by default.
>
> The noVNC client listens on the *container's* TCP port `6901` by default.
>
> The default VNC/noVNC connection password is `headless`.
>
> The default display resolution *inside* the container is `1360x768` pixel with the color depth of 24 bits.
>
> The default VNC session mode is not *view-only*.
>
> The VNC server *inside* the container uses the display number `:1`.
> This parameter is important only in advanced scenarios.
>
> The parameter `NOVNC_HEARTBEAT` has no default value.
> It can prevent the *inactivity disconnections* if the container is used behind a load balancer or reverse proxy.
> For example, `NOVNC_HEARTBEAT=30` will set the *websocket ping/pong interval* to 30 seconds.

{: .note}
The *noVNC client* application forwards all requests to the *VNC server* running *inside* the container and therefore it shares most of the parameters with it.

## At container creation time

You can override the VNC/noVNC parameters by setting the related environment variables *inside the container* when you create it.
This possibility is provided by Docker itself.

For example, the following command would change the VNC connection password to `docker`.

```shell
docker run -d --name devrun -p "35901:5901" -p "36901:6901" -e "VNC_PW=docker" accetto/ubuntu-vnc-xfce-g3
```

You can test the new password by connecting to the container.
The section [Headless working][this-headless-working] explains how to do it.

The created container, running detached in the background, can be removed by the following command:

```shell
docker rm -f devrun
```

However, the environment variables set this way become part of the container configuration, which cannot be changed afterwards.
The same values will be used by each container start.

## At container startup time

All *accetto containers* can override or add the environment variables *at the container-startup time*.
It means, after the container has already been created.

The feature is enabled by default and it can be used also for overriding the VNC/noVNC parameters.

The parameters should be put into the file `$HOME/.override/.override_envv.rc`, which can be provided from outside the container using *volumes* or *bind mounts*.

The page [Overriding environment variables][this-overriding-envv] describes it in details.

### Exercise

{: .use_case}
> Let's create a detached container called `devrun`, which will support overriding its VNC parameters without a need to re-create it.
> We want to change the display number and the display resolution on each container start.
> We want to use *bind mounts* and the overriding file `$HOME/exercise/vnc_parameters.txt` on the host computer.

Begin with preparing a simple text file, which will later contain the `export` statements for the environment variables you want to override.

The initial file can be empty and also its name is not important.

Let's start with creating a new folder called `exercise` in your home directory on the host computer:

```shell
mkdir $HOME/exercise
```

{: .note}
> Creating a new folder is especially important if you have `Docker Desktop for Linux` installed, because it will change the ownership of the folder and its content.
> Read more about this pitfall [here][this-pitfall-docker-desktop-changing-ownership].

Then create an empty file in the new folder:

```shell
touch $HOME/exercise/vnc_parameters.txt
```

Create a new container `devrun`, running detached in the background, using the following command:

```shell
docker run --name devrun -d -p "35901:5901" -p "36901:6901" -v $HOME/exercise/vnc_parameters.txt:/home/headless/.override/.override_envv.rc accetto/ubuntu-vnc-xfce-g3
```

{: .explain}
> Parameter `--name` sets the name of the new container to `devrun`.
>
> Parameter `-d`: The container will keep running detached in the background.
>
> Parameter `-p`: The VNC/noVNC ports 5901/6901 will be bound to the ports 35901/36901 on the host computer.
>
> Parameter `-v`: The host's file `$HOME/exercise/vnc_parameters.txt` will be accessible *inside* the container as the hidden file `/home/headless/.override/.override_envv.rc`.

Check that the display number and the display resolution have their default values.
You can do it even without connecting to the container by using the following command:

```shell
docker exec devrun bash -c 'echo $DISPLAY && echo $VNC_PW && echo $VNC_RESOLUTION'
```

{% include components/callout-terminal.md %}
> <pre>
> :1
> headless
> 1360x768
> </pre>

Stop the container using the command:

```shell
docker stop devrun
```

Now open the file `$HOME/exercise/vnc_parameters.txt` in your favorite text editor and put the following content into the file:

```text
export DISPLAY=:2
export VNC_RESOLUTION=1024x768
export VNC_PW=
```

{: .explain}
> The VNC server should use the display number `:2`.
> Note that the leading colon is required.
>
> The display resolution should be set to `1024x768` pixels.
>
> The VNC/noVNC password should be set to an empty string.
> It effectively disables it.
> However, you'll still get the password prompt.

Now start the container again

```shell
docker start devrun
```

and check the variables using the same command

```shell
docker exec devrun bash -c 'echo $DISPLAY && echo $VNC_PW && echo $VNC_RESOLUTION'
```

Oops! What's wrong?

You see the same output as before:

{% include components/callout-terminal.md %}
> <pre>
> :1
> headless
> 1360x768
> </pre>

Where are the new VNC parameter values from the overriding file?

{: .explain}
> The `docker exec` command from above reads the variable values from the container configuration, which is created when the container is created and stays constant for the whole container life.
>
> The file containing the VNC parameters is processed by the container *startup script*.
> The script will change the variable values *inside* the running container, but it cannot change the values embedded into the container configuration.

Connect to the container as it is explained in the section [Headless working][this-headless-working] and check the variables *inside* the container.

Don't forget that the connection password is empty this time!

Execute the following command in the terminal *inside* the container:

```shell
echo $DISPLAY && echo $VNC_PW && echo $VNC_RESOLUTION
```

{% include components/callout-terminal.md %}
> <pre>
> :2.0
>
> 1024x768
> </pre>

It can be seen that the VNC parameters have been correctly overridden.

The exercise container can be removed using the command:

```shell
docker rm -f devrun
```

## Important remarks

You should be aware, that incorrect overriding of the VNC/noVNC parameters can have severe consequences and it can prevent the container from starting.

This feature assumes sufficient Linux knowledge and it is provided for advanced users that know what they want to achieve.

For example, by convention there is a relation between the `DISPLAY` and `VNC_PORT` values.

The default rules are:

- `VNC_PORT = 5900 + DISPLAY`
- `NOVNC_PORT = 6900 + DISPLAY`

You may decide not to follow the convention, but you should know, what you are doing.

Be also aware, that there are subtle differences between Linux and Windows environments.

{: .tip}
> If your session keeps disconnecting, it might be related to some network equipment (load-balancer, reverse proxy).
> It may be dropping the websocket session for inactivity (more info [here](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) and [here](https://nginx.org/en/docs/http/websocket.html) for nginx).
>
> In such case, try to set the environment variable `NOVNC_HEARTBEAT=XX`, where `XX` is the number of seconds between the [websocket ping/pong](https://github.com/websockets/ws/issues/977) packets.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/overriding-envv/
[this-goto-next-page]: {{site.baseurl}}/installing-packages/

[this-headless-working]: {{site.baseurl}}/headless-working/
[this-using-compose]: {{site.baseurl}}/using-compose/
[this-overriding-envv]: {{site.baseurl}}/overriding-envv/
[this-extending-examples]: {{site.baseurl}}/using-compose/extending-examples/

[this-overriding-vnc-important-remarks]: {{site.baseurl}}/overriding-vnc/#important-remarks

[this-pitfall-docker-desktop-changing-ownership]: {{site.baseurl}}/using-bind-mounts/#pitfall-docker-desktop-for-linux-changing-ownership
