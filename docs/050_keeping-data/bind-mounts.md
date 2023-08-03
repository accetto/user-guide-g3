---
layout: default
title: Using bind mounts
parent: Keeping data
permalink: /using-bind-mounts/
nav_order: "050.30"
---

# Using bind mounts
{: .fs-9 }

that are managed by host system
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Using *bind mounts* is the oldest and the *most troublesome* way of persisting container data *outside* the container.

[Docker Docs: Bind mounts][docker-docs-bind-mounts]{: .btn .fs-2 }

{% include components/collapsible-toc.md %}

The advantage of using *bind mounts* is, that their content can be easily accessed from the host computer, if the user has sufficient permissions.
This makes modifications and backups simpler comparing to *volumes*.

They also support binding of single files, not only the whole folders.

The disadvantage of *bind mounts* is, that they are managed by the *host system* and therefore they are very sensitive to the differences between [environments][this-environments].
Handling file permissions and ownership can be sometimes a real nightmare.

<!-- {: .highlight} -->
> <span class="text-delta">
> From Docker Docs
> <br/>
> </span>
> *Bind mounts* may be stored anywhere on the host system.
> They may even be important system files or directories.
> Non-Docker processes on the Docker host or a Docker container can modify them at any time.

Because the *Docker CLI* functionality is evolving, it's recommended to follow the section [Bind mounts][docker-docs-bind-mounts] in the official Docker documentation.

{: .important}
> Before persisting data outside the container you should read the section [Manage data in Docker][docker-docs-storage] in the official Docker documentation.

{% include components/collapsible-toc.md %}

## Exercise 1

{: .use_case}
> Let's say that you want to persist the container's folder `/home/headless/Documents` in the folder `$HOME/my-documents` on the host computer.
> You want to name the container `devrun`.

You can do it by creating the container using the following command:

```shell
docker run -d --name devrun -p "35901:5901" -p "36901:6901" -v "$HOME/my-documents:/home/headless/Documents" accetto/ubuntu-vnc-xfce-g3
```

You can connect to the container as it's described in the section [Headless working][this-headless-working] and store some files into the folder `/home/headless/Documents`.

Then you can remove the container using the command:

```shell
docker container rm -f devrun
```

You can verify that the folder `$HOME/my-documents` on your host computer has not been removed with the container.

If you now re-create the container, it will use the same folder on your host computer and all the data will be still there, until the data or the folder are deleted.

{: .important}
> If you are on Linux with `Docker Desktop` installed, you will notice that the ownership of the folder `$HOME/my-documents` has changed.
> You may not be able to remove the folder without using elevated permissions (`sudo`).
> It's the case even if you've created the folder yourself before creating the container.
> The reason is explained in the chapter about the [Docker Desktop for Linux pitfall][this-pitfall-docker-desktop-for-linux-changing-ownership].

## Pitfall `HOME binding`

{: .pitfall}
> <span class="text-delta">
> HOME binding
> <br/>
> </span>
> Avoid binding the whole `$HOME` directory in the container to an external folder.
> It will not work *correctly* in most cases on most environments, because the `$HOME` directory will not be *completely and correctly* initialized.
> It can *seemingly* work on some environments and you can even get it working on some other, if you have enough knowledge, but this scenario is currently *not recommended* and *not supported*.
> One sign of *incomplete initialization* of the `$HOME` directory is the missing `Version Sticker` launcher on the desktop.

{: .use_case}
Let's create a detached container named `pitfall-bind` and bind the whole home directory `/home/headless` to the folder `$HOME/pitfall-home-binding-using-bind` on the host computer.

Create the container using the following command:

```shell
docker run --name pitfall-bind --hostname pitfall-bind -d -p "35901:5901" -p "36901:6901" -v "$HOME/pitfall-home-binding-using-bind:/home/headless" accetto/ubuntu-vnc-xfce-g3
```

You will end up with the *seemingly correct* container shown on the following screenshot:

![HOME binding using bind][this-image-pitfall-home-binding-using-bind]

You can see, that some launchers on the desktop are missing, including the `Version Sticker` launcher.
You will also find out, that not all usual subdirectories of the `$HOME` folder have been created.
You'll also get some troubles with the permissions.

The correctly initialized container would look like this:

![correctly-initialized-container][this-image-pitfall-home-binding-using-volume]

You can remove the exercise container using the following command:

```shell
docker rm -f pitfall-bind
```

Note that the folder on your host computer is not removed with the container.
You can create another container and re-use the same folder.
All the previous container data will be still there.

You can remove the exercise folder using the following command:

```shell
rm -rf $HOME/pitfall-home-binding-using-bind/
```

{: .important}
> If you are on Linux with `Docker Desktop for Linux` installed, then you may not be able to remove the folder `$HOME/pitfall-home-binding-using-bind` on your host computer without using elevated permissions (`sudo`).
> It's the case even if you've created the folder yourself before creating the container.
> The reason is explained in the chapter about the [Docker Desktop for Linux pitfall][this-pitfall-docker-desktop-for-linux-changing-ownership].

## Avoiding pitfall `HOME binding`

{: .tip}
> One way around the `HOME binding` pitfall is to create and *initialize* the container first, then copy out the whole `$HOME` directory (see [Data inside][this-data-inside]) and only then to bind it to the container.

Even simpler is to bind the whole `$HOME` directory to a [volume][this-using-volumes].

{: .use_case}
> Let's create a detached container named `pitfall-volume` and bind the whole home directory `/home/headless` to a named volume `pitfall-home-binding-volume`.

```shell
docker run --name pitfall-volume --hostname pitfall-volume -d -p "35901:5901" -p "36901:6901" -v "pitfall-home-binding-volume:/home/headless" accetto/ubuntu-vnc-xfce-g3
```

This time is the container initialized correctly:

![HOME binding using volume][this-image-pitfall-home-binding-using-volume]

You can remove the exercise container using the following command:

```shell
docker rm -f pitfall-volume
```

Note that the volume *is not* removed with the container.

You can verify it using the following command:

```shell
docker volume ls
```

{% include components/callout-terminal.md %}
> <pre>
> DRIVER    VOLUME NAME
> local     pitfall-home-binding-volume
> </pre>

You can create another container and re-use the same volume.
All the previous container data will be still there.

You can remove the exercise volume using the following command:

```shell
docker volume rm pitfall-home-binding-volume
```

## Pitfall `Docker Desktop for Linux changing ownership`

{: .pitfall}
> <span class="text-delta">
> Docker Desktop for Linux changing ownership
> <br/>
> </span>
> If you are on Linux with `Docker Desktop for Linux` installed, then you'll notice, that Docker Desktop keeps changing the ownership of the folders on your host system, that are used for *bind mounts*.

This behavior is specific to `Docker Desktop for Linux` and it is caused by using [virtiofs][virtiofs] for sharing files between the host and the containers.

As the result, `Docker desktop for Linux` maps the current user ID and GID to 0 in the containers.
For this to work, the system files `/etc/subuid` and `/etc/subgid` must exist on the host computer.

The ownership of the folders used for the *bind mounts* is usually set to `100999:100999`, because the UID/GID range defined by the system files mentioned above is typically `100000:65536`.

There is currently no way to change this behavior.
You can read more about it in the official Docker documentation [here][docker-docs-docker-desktop-for-linux-file-sharing-faq] and [here][docker-docs-isolate-containers-using-user-namespaces].

This discrepancy in behavior between different `Docker Desktop` releases is unfortunate, but there are still enough reasons for using also `Docker Desktop for Linux`.

The description below shows two ways how to mitigate the inconvenience.

### Exercise 2

{: .use_case}
> Let’s create a detached container named `pitfall-desktop` and bind its folder `/home/headless/Documents` to the folder `$HOME/pitfall-docker-desktop` on your host computer.
>
> Let's create the folder on the host *before* creating the container.
> It will allows you to check the folder ownership before the binding takes place.
>
> Let's also ensure that the current directory is your home directory on the host.

Create the folder for binding using the following command:

```shell
mkdir pitfall-docker-desktop
```

Now check the folder ownership using the following command:

```shell
getfacl -n pitfall-docker-desktop/
```

{% include components/callout-terminal.md %}
> <pre>
> # file: pitfall-docker-desktop/
> # owner: 1000
> # group: 1000
> user::rwx
> group::r-x
> other::r-x
> </pre>

Create the exercise container using the following command:

```shell
docker run --name pitfall-desktop --hostname pitfall-desktop -d -p "35901:5901" -p "36901:6901" -v "$HOME/pitfall-docker-desktop:/home/headless/Documents" accetto/ubuntu-vnc-xfce-g3
```

Now you can already see that the folder ownership has indeed changed:

```shell
getfacl -n pitfall-docker-desktop/
```

{% include components/callout-terminal.md %}
> <pre>
> # file: pitfall-docker-desktop/
> # owner: 100999
> # group: 100999
> user::rwx
> group::r-x
> other::r-x
> </pre>

The exercise container can be removed using the following command:

```shell
docker rm -f pitfall-desktop
```

The exercise folder can be removed using the following command:

```shell
rm -rf pitfall-docker-desktop
```

{: .note}
> You may need elevated `sudo` permissions for removing the folder.

## Mitigating pitfall `Docker Desktop for Linux changing ownership`

This pitfall is actually not so bad as it seems, if you're able and willing to make a few adjustments on your host computer.

If you don't want or can't to do that, then a few simple aliases can also help with the problem.

{: .use_case}
> Let's say you want to use the GIMP container for processing the screenshots you're taking on the host computer.
> You want to store the screenshots into the folder `$HOME/pitfall-docker-desktop` on the host computer.
> The folder will be bound to the container's folder `/home/headless/Documents`.
> You're on Linux and you have `Docker Desktop for Linux` installed.
> The current directory is your home directory on the host.

In this scenario you'll probably become annoyed by the changing ownership of the bound folder pretty soon, because you need to access the folder from the host and also from the container each time you take and then process a screenshot.

Create the folder for binding using the following command:

```shell
mkdir pitfall-docker-desktop
```

Create the exercise container with GIMP using the following command:

```shell
docker run --name pitfall-desktop --hostname pitfall-desktop -d -p "35901:5901" -p "36901:6901" -v "$HOME/pitfall-docker-desktop:/home/headless/Documents" accetto/ubuntu-vnc-xfce-gimp-g3
```

After the image is downloaded and the container created, you can check the changed ownership of the bound folder:

```shell
getfacl -n pitfall-docker-desktop/
```

{% include components/callout-terminal.md %}
> <pre>
> # file: pitfall-docker-desktop/
> # owner: 100999
> # group: 100999
> user::rwx
> group::r-x
> other::r-x
> </pre>

Let's look at two ways how to mitigate the inconvenience caused by the changed ownership of the shared folder.

### Mitigation 1 (group)

The best approach is to create an appropriate user group on the host computer, put the user running the Docker Desktop application into it and then to adjust the permissions of the shared folder.

Let's begin with creating a new user group on the host computer:

```shell
sudo groupadd -g 100999 dockerdesktop
```

{: .explain}
> The GID must be `100999`, the same value as Docker Desktop is using.
>
> The user group name is `dockerdesktop`, but it can be any name that doesn't exist on the host computer yet.

Assuming that the Docker Desktop application runs under you account, put yourself into the new user group:

```shell
sudo usermod -aG dockerdesktop $(whoami)
```

You'll need to logout and then login again to apply the group membership changes.
However, let's finish the second part of the adjustments first.

You have to ensure, that the bound folder and its content belong to the new group:

```shell
sudo chgrp -R dockerdesktop pitfall-docker-desktop/
```

You also have to ensure that the new group is able to change the shared content:

```shell
sudo chmod -R g+w pitfall-docker-desktop/
```

Check the adjustments:

```shell
getfacl -n pitfall-docker-desktop/
```

{% include components/callout-terminal.md %}
> <pre>
> # file: pitfall-docker-desktop/
> # owner: 100999
> # group: 100999
> user::rwx
> group::rwx
> other::r-x
> </pre>

You can remove the exercise container before you logout:

```shell
docker rm -f pitfall-desktop
```

After you login again, the changes in your group membership has been already applied and you should be able to remove the exercise folder without needing elevated permissions:

```shell
rm -rf pitfall-docker-desktop
```

### Mitigation 2 (aliases)

If you don't want or can't make changes on your host computer, you can create simple aliases for taking back the ownership of the shared folders.

Create one set of aliases on the host and one in the container.

If the folder path is the same on the host and in the container, you can use the same code in both environments.
Otherwise adjust the target path appropriately.

For example:

```shell
alias allmine='sudo chown -R "$(id -u):$(id -g)" $HOME/Pictures/Screenshots/'
```

{: .explain}
> Each time you have problems with the ownership of the bound folder, you execute the alias `allmine` in the current environment and it will set the current user account as the owner of the whole folder content.

{: .tip}
> Put the commands creating the aliases into the file `$HOME/.bashrc`.
> The aliases will be then available in all terminal sessions.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/using-volumes/
[this-goto-next-page]: {{site.baseurl}}/using-compose/

[this-environments]: {{site.baseurl}}/environments/
[this-data-inside]: {{site.baseurl}}/data-inside/
[this-using-volumes]: {{site.baseurl}}/using-volumes/
[this-headless-working]: {{site.baseurl}}/headless-working/

[this-pitfall-docker-desktop-for-linux-changing-ownership]: {{site.baseurl}}/using-bind-mounts/#pitfall-docker-desktop-for-linux-changing-ownership

[this-image-pitfall-home-binding-using-bind]: {{site.baseurl}}/assets/images/pitfall-home-binding-using-bind.png

[this-image-pitfall-home-binding-using-volume]: {{site.baseurl}}/assets/images/pitfall-home-binding-using-volume.png

[docker-docs-storage]: https://docs.docker.com/storage/
[docker-docs-bind-mounts]: https://docs.docker.com/storage/bind-mounts/

[docker-docs-docker-desktop-for-linux-file-sharing-faq]: https://docs.docker.com/desktop/faqs/linuxfaqs/#how-do-i-enable-file-sharing

[docker-docs-isolate-containers-using-user-namespaces]: https://docs.docker.com/engine/security/userns-remap/

[virtiofs]: https://virtio-fs.gitlab.io/
