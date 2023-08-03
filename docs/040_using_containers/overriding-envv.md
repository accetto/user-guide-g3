---
layout: default
title: Overriding ENVV
parent: Using containers
permalink: /overriding-envv/
nav_order: "040.050"
---

# Overriding environment
{: .fs-9 }

variables inside the container
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
The environment variables inside the container can be overridden *at the image build time*, *at the container creation time* or *at the container startup time*.
The latter is a unique feature of *accetto containers*.

{% include components/collapsible-toc.md %}

## At image build time

Building *accetto images* lies outside the scope of this *User guide*.
However, the container environment variables can be overridden also by [Extending images][this-extending-examples].

Environment variable values set during the image build time become part of the image and they cannot be changed afterwards, only overridden.
They are inherited by each container created from the image.

## At container creation time

Overriding environment variables inside the container is supported by the `docker run` command by default.

It can be used by providing the parameter `-e` to the command `docker run`.
It can be provided multiple times.

[Docker Docs][docker-docs-run-env-environment-variables]{: .btn .fs-2 }

However, the environment variables set this way become part of the container configuration, which cannot be changed afterwards.

The variables can be changed inside a running container, but such changes will not be persisted.
When the container is stopped, the changes are lost and by the next start they will set to the values from the container configuration again.

One way around this limitation is to export the variables in the file `$HOME/.bashrc` and provide the file from outside the container using *volumes* or *bind mounts*.

Another way is to use the ability to override the environment variables *at the container-startup time*, which is provided by the *accetto containers* and described below.

### Exercise 1

{: .use_case}
> Let's to prove that the run-time changes of the environment variable values are not persistent.

Let's use the standard and unmodified Ubuntu image for this exercise.

Create a new interactive container using the following command:

```shell
docker run -it --name devrun -e STAGE=development ubuntu
```

After the container is started, execute the commands shown in the following terminal window.

Note that the parameter `--rm` is not used this time and that a new environment variable `STAGE=development` is created.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> root@7066e343cfb3:/# echo $STAGE
> development
>
> root@7066e343cfb3:/# export STAGE=devrun
>
> root@7066e343cfb3:/# echo $STAGE
> devrun
>
> root@7066e343cfb3:/# exit
> exit
> </pre>

First you've checked that the initial value of the `STAGE` variable was `development` and then you've changed it into `devrun`.

After executing `exit` the container was stopped, but not removed.

Let's start the container interactively again using the following command:

```shell
docker start -ai devrun
```

After the container is started, execute the commands shown in the following terminal window.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> root@7066e343cfb3:/# echo $STAGE
> development
>
> root@7066e343cfb3:/# exit
> exit
> </pre>

You've proved, that the run-time change has not been persisted, because the `STAGE` variable again has its initial value `development`, which has been persisted in the container configuration when the container has been created by the `docker run` command.

The exercise container can be removed using the following command:

```shell
docker rm -f devrun
```

## At container startup time

All *accetto containers* can override or add the environment variables *at the container-startup time*.
It means, after the container has already been created.

The feature is enabled by default.

It can be disabled by setting the variable `FEATURES_OVERRIDING_ENVV` to zero when the container is created or the image is built. Be aware that any other value than zero, even if unset or empty, enables the feature.

If `FEATURES_OVERRIDING_ENVV=1`, then the container *startup script* will look for the file `$HOME/.override/.override_envv.rc` and source all the lines that begin with the string 'export ' at the first position and contain the equals ('=') character.

The overriding file can be provided from outside the container using *bind mounts* or *volumes*.

The lines that have been actually sourced can be reported into the container's log if the startup parameter `--verbose` or `--debug` is provided.

Environment variables added or overridden at *at the container startup-time* are not persisted in the container configuration file, but in the overriding file, which is bound as `$HOME/.override/.override_envv.rc`.

Consequently, the new variable values are available inside the running container, but Docker tools like, for example, the command `docker inspect` will still report the values persisted in the container configuration file.
Also the exercise in the section [Overriding VNC][this-overriding-vnc-exercise] illustrates this behavior.

{: .important}
> The container must be created with overriding in mind and include the appropriate mounts.
>
> The overriding file is processed by the *startup script*, therefore it should not be skipped.

### Exercise 2 (bind mounts)

{: .use_case}
> Let's to add a new environment variable `STAGE=development` to an already existing container.
> Let's also change the value to something else later.
> We want to use *bind mounts* and the overriding file `$HOME/exercise/my-override-envv.txt` on the host computer.

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
touch $HOME/exercise/my-override-envv.txt
```

Create a new interactive container named `devrun` using the following command:

```shell
docker run -it --name devrun \
-v $HOME/exercise/my-override-envv.txt:/home/headless/.override/.override_envv.rc \
accetto/ubuntu-vnc-xfce-g3 bash
```

{: .explain}
> Parameter `-it` causes the container to run interactively in the foreground.
>
> Note that there is no `--rm` this time.
> Therefore the container the container will not be automatically removed after it's stopped.
>
> Parameter `--name` names the container `devrun`.
>
> Parameter `-v` binds the file `$HOME/exercise/my-override-envv.txt` on the host computer as the file `/home/headless/.override/.override_envv.rc` inside the container.
>
> Parameter `bash` starts an interactive shell session inside the container.

After the container is started, execute the commands shown in the following terminal window.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@ee99b893aee6:~$ echo $FEATURES_OVERRIDING_ENVV
> 1
>
> headless@ee99b893aee6:~$ ls $HOME/.override/.override_envv.rc
> /home/headless/.override/.override_envv.rc
>
> headless@ee99b893aee6:~$ cat $HOME/.override/.override_envv.rc
>
> headless@ee99b893aee6:~$ echo $STAGE
>
> headless@ee99b893aee6:~$ exit
> exit
> ^C
> </pre>

After executing `exit` and then pressing `CTRL-c`, the container has been stopped, but not removed.

The following can be seen:

- feature `FEATURES_OVERRIDING_ENVV` is enabled
- overriding file exists and it's empty
- environment variable `STAGE` is not set

Let's put the following content into the overriding file `my-override-envv.txt` on the host computer:

```text
export STAGE=development

```

Now start the container interactively again using the following command:

```shell
docker start -ai devrun
```

After the container is started, execute the commands shown in the following terminal window.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@ee99b893aee6:~$ echo $STAGE
> development
>
> headless@ee99b893aee6:~$ exit
> exit
> ^C
> </pre>

The variable `STAGE=development` has been indeed added.

Let's change its value in the overriding file `my-override-envv.txt` on the host into `testing`. and repeat the same test again.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@ee99b893aee6:~$ echo $STAGE
> testing
>
> headless@ee99b893aee6:~$ exit
> exit
> ^C
> </pre>

It can be seen that the variable `STAGE` ahs indeed the new value `testing`.

The exercise container can be removed using the following command:

```shell
docker rm -f devrun
```

### Exercise 3 (disabled)

{: .use_case}
> Let's prove that the overriding feature can be disabled even if the container has been created with the overriding mount.

Let's assume that the overriding file `$HOME/exercise/my-override-envv.txt` from the previous exercise still exists and that it has the following content:

```text
export STAGE=testing

```

Let's create a new exercise container also called `devrun`, but this time overriding the variable `FEATURES_OVERRIDING_ENVV`:

```shell
docker run -it --name devrun \
-v $HOME/exercise/my-override-envv.txt:/home/headless/.override/.override_envv.rc \
-e FEATURES_OVERRIDING_ENVV=0 \
accetto/ubuntu-vnc-xfce-g3 bash
```

After the container is started, execute the commands shown in the following terminal window.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@c6ad66cfdb82:~$ cat $HOME/.override/.override_envv.rc
> export STAGE=testing
>
> headless@c6ad66cfdb82:~$ echo $STAGE
>
> headless@c6ad66cfdb82:~$ echo $FEATURES_OVERRIDING_ENVV
> 0
>
> headless@c6ad66cfdb82:~$ exit
> exit
> ^C
> </pre>

It can be seen that even the overriding file is available inside the container and its content is valid, the environment variable `STAGE` has not been set.
It's because the variable `FEATURES_OVERRIDING_ENVV` has been set to zero.

{: .important}
> The environment variable `FEATURES_OVERRIDING_ENVV` is persisted in the container configuration and it cannot be overridden without overriding also the startup script.

The exercise container can be removed using the following command:

```shell
docker rm -f devrun
```

### Exercise 4 (volumes)

{: .use_case}
> Let's to add a new environment variable `STAGE=development` to an already existing container.
> Let's use a named volume `exercise-overriding-envv` for providing the overriding file.

Let's create a new interactive container called `devrun` using the following command:

```shell
docker run -it --name devrun \
-v exercise-overriding-envv:/home/headless/.override \
accetto/ubuntu-vnc-xfce-g3 bash
```

{: .explain}
> Parameter `-it` causes the container to run interactively in the foreground.
>
> Note that there is no `--rm` this time.
> Therefore the container the container will not be automatically removed after it's stopped.
>
> Parameter `--name` names the container `devrun`.
>
> Parameter `-v` binds the named volume 'exercise-overriding-envv' to the folder `/home/headless/.override/` inside the container.
> If the volume doesn't exist yet, then it will be created.
> If it already exists, then it will be reused.
> The folder `$HOME/.override/` inside the container will be created automatically.
> Note that only the whole folder can be bound to the volume.
>
> Parameter `bash` starts an interactive shell session inside the container.

After the container is started, execute the commands shown in the following terminal window.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@6b5ed54e6a6e:~$ echo $FEATURES_OVERRIDING_ENVV
> 1
>
> headless@6b5ed54e6a6e:~$ ls -a $HOME/.override/
> .  ..
>
> headless@6b5ed54e6a6e:~$ echo $STAGE
>
> headless@6b5ed54e6a6e:~$ exit
> exit
> ^C
> </pre>

After executing `exit` and then pressing `CTRL-c`, the container has been stopped, but not removed.

It can be seen, that the overriding feature is enabled and also the folder `$HOME/.override/` inside the container has been created.
However, the environment variable `STAGE` has not been set, because there no overriding file `.override-envv.rc` in the volume yet.

There are several ways to populate *volumes*.

One of them is to create the overriding file using the container itself.

Let's start the container interactively again.

```shell
docker start -ai devrun
```

After the container is started, execute the commands shown in the following terminal window.

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@6b5ed54e6a6e:~$ echo 'export STAGE=development' >$HOME/.override/.override_envv.rc
>
> headless@6b5ed54e6a6e:~$ cat $HOME/.override/.override_envv.rc
> export STAGE=development
>
> headless@6b5ed54e6a6e:~$ exit
> exit
> ^C
> </pre>

After this the volume `exercise-overriding-envv`, already containing the overriding file `.override_envv.rc`, can be re-used or used concurrently by several containers.

Let's remove the container, but not the volume:

```shell
docker rm -f devrun
```

After creating a new container and using the same volume we can check the overriding:

```shell
docker run -it --name devrun \
-v exercise-overriding-envv:/home/headless/.override \
accetto/ubuntu-vnc-xfce-g3 bash
```

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> headless@557d64d03d2c:~$ echo $STAGE
> development
>
> headless@557d64d03d2c:~$ exit
> exit
> ^C
> </pre>

It can be seen that the environment variable `STAGE` has indeed been added.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/overriding-user/
[this-goto-next-page]: {{site.baseurl}}/overriding-vnc/

[this-extending-examples]: {{site.baseurl}}/using-compose/extending-examples/

[this-overriding-vnc-exercise]: {{site.baseurl}}/overriding-vnc/#exercise

[this-pitfall-docker-desktop-changing-ownership]: {{site.baseurl}}/using-bind-mounts/#pitfall-docker-desktop-for-linux-changing-ownership

[docker-docs-run-env-environment-variables]: https://docs.docker.com/engine/reference/run/#env-environment-variables
