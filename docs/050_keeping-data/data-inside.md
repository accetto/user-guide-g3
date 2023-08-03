---
layout: default
title: Inside containers
parent: Keeping data
permalink: /data-inside/
nav_order: "050.10"
---

# Data inside containers
{: .fs-9 }

easy but impermanent way
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
The simplest and fastest way of keeping container data is to store them inside the container.

{% include components/collapsible-toc.md %}

Keeping data inside the containers requires no preparation, works out-of-the-box and brings no problems with file permissions and ownership of newly created data.

However, the lifespan of the data in this case is equal to the lifetime of the container.
The data is lost after the container is deleted or re-created.

Anyhow, it's the most suitable way of keeping container data in many scenarios.
Especially if the container itself is only for temporary use, there is no reason to keep its data outside it.

{: .important}
> Data stored *inside* the container will survive the container *re-starts*.
> However, they will not survive the container *re-creations*.

## Exporting container data

You can selectively get out data from a running container by using the command `docker cp`.
There is also the alias `docker container cp`.

{: .use_case}
> Let's say that you've created a detached container named `devrun` using the following command:
>
> ```shell
> docker run -d -p "35901:5901" -p "36901:6901" --name devrun --hostname > devrun accetto/ubuntu-vnc-xfce-firefox-g3
> ```
>
> Then you have connected to the container as it is described in the section [Headless working][this-headless-working] and using the Firefox browser downloaded some data into the folder `/home/headless/Downloads`.
>
> Now you want to copy the whole content of the folder `/home/headless/Downloads` to the `my-copy` subfolder of your current directory.

You can do it by using the following commands:

```shell
mkdir my-copy
docker cp devrun:/home/headless/Downloads ./my-copy/
```

You should find the data in the folder `./my-copy/Downloads`.

## Persisting whole container

You can persist container data also by persisting the whole container.

It can be done two ways.

### Exporting container

You can export the whole container's file system as a `tar` archive using the command `docker export`.
There is also the alias `docker container export`.

This is how you would export the `devrun` container you've created above as a new archive file `devrun.tar` in your current directory:

```shell
docker export --output devrun.tar devrun
```

{: .warning}
> Do not forget to provide the `--output` (or `-o`) option because the default output target is the console's `STDOUT` stream!

{: .note}
> Exporting containers can take some time, so don't be impatient and don't try to interrupt the export process prematurely.
> Note also that the result archive files could be quite large and that the contents of volumes associated with the container will not be exported.

The created file `devrun.tar` can be used for restoring the image from which the `devrun` container has been created.
You can use the command `docker load` for that.

### Committing container

The command `docker commit` creates a new image from a container’s changes.
There is also the alias `docker container commit`.

The command is similar to the previous `docker export` command, but has some additional options.
Please refer to the official [Docker CLI documentation][docker-docs-cli-reference] for the description.

{: .note}
> The contents of volumes associated with the container will not be committed.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/keeping-data/
[this-goto-next-page]: {{site.baseurl}}/using-volumes/

[this-headless-working]: {{site.baseurl}}/headless-working/

[docker-docs-cli-reference]: https://docs.docker.com/engine/reference/commandline/cli/
