---
layout: default
title: Using volumes
parent: Keeping data
permalink: /using-volumes/
nav_order: "050.20"
---

# Using volumes
{: .fs-9 }

that are managed by Docker
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Using *volumes* is your best bet if you want to keep the container data *outside* the container.

[Docker Docs: Volumes][docker-docs-volumes]{: .btn .fs-2 }

{% include components/collapsible-toc.md %}

The advantage of *volumes* is, that they are managed by Docker itself and that they offer more functions and options then *bind mounts*.

The disadvantage of *volumes* is, that their content cannot be easily accessed from the host computer.
This makes modifications and backups more complicated comparing to *bind mounts*.

They also don't support binding of single files, only the whole volumes.

<!-- {: .highlight} -->
> <span class="text-delta">
> From Docker Docs
> <br/>
> </span>
> *Volumes* are stored in a part of the host filesystem which is managed by Docker (`/var/lib/docker/volumes/` on Linux).
> Non-Docker processes should not modify this part of the filesystem.
> Volumes are the best way to persist data in Docker.

Because the *Docker CLI* functionality is evolving, it's recommended to follow the section [Volumes][docker-docs-volumes] in the official Docker documentation.

{: .important}
> Before persisting data outside the container you should read the section [Manage data in Docker][docker-docs-storage] in the official Docker documentation.

## Exercise

{: .use_case}
> Let's say that you want to persist the container's folder `/home/headless/Documents` in the named Docker volume `my-documents`.
> If the volume does not exist yet, it should be created.
> Otherwise it should be re-used.
> You want to name the container `devrun`.

You can do it by creating the container using the following command:

```shell
docker run -d --name devrun -p "35901:5901" -p "36901:6901" -v "my-documents:/home/headless/Documents" accetto/ubuntu-vnc-xfce-g3
```

You can connect to the container as it's described in the section [Headless working][this-headless-working] and store some files into the folder `/home/headless/Documents`.

Then you can remove the container using the command:

```shell
docker container rm -f devrun
```

You can verify that the volume has not been removed with the container by using the following command:

```shell
docker volume ls
```

If you now re-create the container, it will use the same volume and all the data will be still there, until the volume is deleted.

You can delete the volume explicitly using the following command:

```shell
docker volume rm my-documents
```

{: .tip}
> Also the exercise [Avoiding pitfall `HOME binding`][this-avoiding-home-binding-pitfall] uses Docker volumes.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/data-inside/
[this-goto-next-page]: {{site.baseurl}}/using-bind-mounts/

[this-headless-working]: {{site.baseurl}}/headless-working/

[this-avoiding-home-binding-pitfall]: {{site.baseurl}}/using-bind-mounts/#avoiding-pitfall-home-binding

[docker-docs-storage]: https://docs.docker.com/storage/
[docker-docs-volumes]: https://docs.docker.com/storage/volumes/
