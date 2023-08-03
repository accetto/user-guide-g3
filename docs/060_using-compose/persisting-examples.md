---
layout: default
title: Persisting examples
parent: Using Compose
permalink: /using-compose/persisting-examples/
nav_order: "060.40"
---

# Examples of services
{: .fs-9 }

that keep data outside containers
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Examples in this chapter create containers that persist data outside themselves.

[Docker Docs: Compose CLI][docker-docs-compose-cli]{: .btn .fs-2 }
[Docker Docs: Compose file reference][docker-docs-compose-file-reference]{: .btn .fs-2 }
[Examples: Compose][github-accetto-user-guide-g3-examples-compose]{: .btn .fs-2 }

The images and containers are created or deleted by the services defined in the common *Compose file* called `persisting.yml`.

It's assumed that the *current directory* is the one which contains the *Compose files*.

{% include components/collapsible-toc.md %}

## Handling services

The chapter about [basic examples][this-using-compose-basic-examples] describes how to start and stop the services all at once or individually.

You can use the same commands also for these examples, just providing the *Compose file* name `persisting.yml` and the appropriate profile name.

## Firefox container using volumes

This sample service creates a container, which persists the Firefox profile in a *named Docker volume*.

Using [volumes][this-using-volumes] is the most reliable way to persist container data outside the container, because they are managed by Docker and therefore work across all environments.

The following fragment of the sample *Compose file* `persisting.yml` defines the service `firefox-using-volumes`:

```yaml
services:
  firefox-using-volumes:
    profiles:
      - all
      - firefox-using-volumes
    build:
      context: ./docker
      dockerfile: Dockerfile
      target: stage_persisting-firefox
    image: example-persisting:firefox
    container_name: example-persisting-firefox-using-volumes
    hostname: example-persisting-firefox-using-volumes
    shm_size: "256m"
    environment:
      - VNC_RESOLUTION=1024x768
    ports:
      - "45901:5901"  # VNC
      - "46901:6901"  # noVNC
    volumes:
      - type: volume
        source: firefox-profile-volume
        target: /home/headless/.mozilla/firefox
volumes:
  firefox-profile-volume:
```

{: .explain}
> Element `services` contains the definition of the service `firefox-using-volumes`.
>
> Key `profiles`: The service is part of the profiles `all` and `firefox-using-volumes`.
>
> Key `build`: A new image `example-persisting:firefox` is built from the stage `stage_persisting-firefox` of the `Dockerfile`.
>
> The rest of the keys defines the configuration of a new container `example-persisting-firefox-using-volumes`, which will be created and started detached in the background.
>
> Element `volumes`: The Firefox profile will be persisted in the named Docker volume `example-persisting_firefox-profile-volume`.

The service can be started using the following command:

```shell
docker compose --profile firefox-using-volumes -f persisting.yml -p example-persisting up -d
```

You can check that the new image has been created:

```shell
{% raw %}docker images --filter=reference='example-persisting:*' --format 'table {{.Repository}}\t{{.Tag}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> REPOSITORY           TAG
> example-persisting   firefox
> </pre>

There should be also the new container running:

```shell
{% raw %}docker container ls --filter 'name=example-persisting' --format 'table {{.Names}}\t{{.Status}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> NAMES                                      STATUS
> example-persisting-firefox-using-volumes   Up About a minute
> </pre>

Finally, there should be the new named volume:

```shell
{% raw %}docker volume ls -f name='example-persisting' --format '{{.Name}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> example-persisting_firefox-profile-volume
> </pre>

### Checking volume persistency

Connect to the container as it is described in the section [Headless working][this-headless-working] and start the Firefox browser.
It will create and initialize the Firefox profile.

Then make some changes in Firefox settings that you can later recognize.

You can, for example, change the setting `Homepage and new windows` from its default value `Firefox Home (Default)` to `Blank Page`.

Then close Firefox browser and disconnect from the container.

Stop the service using the following command:

```shell
docker compose --profile firefox-using-volumes -f persisting.yml -p example-persisting down
```

Note that the image and the volume have not been removed, only the container is gone.
You can verify it using the commands provided above.

Now you can start the service again using the same command as above:

```shell
docker compose --profile firefox-using-volumes -f persisting.yml -p example-persisting up -d
```

Only the container will be create as new, the existing image and volume will be re-used.

Now connect to the container again and start Firefox browser.

You should see a blank home page.

It proves that the Firefox profile has been persisted and that it has survived the container re-creation.

You can re-use the named Docker volume `example-persisting_firefox-profile-volume` again and again until you explicitly remove it.

Similarly you can reuse the created Docker image.

### Removing volume assets

You can remove the created image, container and volume several ways, using different Docker CLI commands.

You can also use the following *Compose* commands.

Removing the container, but keeping the image and volume:

```shell
docker compose --profile firefox-using-volumes -f persisting.yml -p example-persisting down
```

Removing the container and volume, but keeping the image:

```shell
docker compose --profile firefox-using-volumes -f persisting.yml -p example-persisting down --volumes
```

Removing the image, container and volume at once:

```shell
docker compose --profile firefox-using-volumes -f persisting.yml -p example-persisting down --volumes --rmi all
```

## Firefox container using bind mounts

This sample service is similar to the previous one, only the created container uses *bind mounts* to persist its data.

Additionally to the Firefox profile data also the files saved into the container's folder `/home/headless/Downloads` will be persisted.

{: .warning}
> Be aware that using *bind mounts* could be challenging, depending on your current environment and knowledge level.
> There are also some pitfalls, as described in the section about [using bind mounts][this-using-bind-mounts].
> Using [volumes][this-using-volumes] is always a safer bet.

The following fragment of the sample *Compose file* `persisting.yml` defines the service `firefox-using-binds`:

```yaml
services:
  firefox-using-binds:
    profiles:
      - all
      - firefox-using-binds
    build:
      context: ./docker
      dockerfile: Dockerfile
      target: stage_persisting-firefox
    image: example-persisting:firefox
    container_name: example-persisting-firefox-using-binds
    hostname: example-persisting-firefox-using-binds
    environment:
      - VNC_RESOLUTION=1024x768
    ports:
      - "45902:5901"  # VNC
      - "46902:6901"  # noVNC
    volumes:
      - type: bind
        source: ${HOME}/compose-samples/firefox-profile
        target: /home/headless/.mozilla/firefox
      - type: bind
        source: ${HOME}/compose-samples/Downloads
        target: /home/headless/Downloads
```

{: .explain}
> Key `profiles`: The service is part of the profiles `all` and `firefox-using-volumes`.
>
> Key `build`: A new image `example-persisting:firefox` is built from the stage `stage_persisting-firefox` of the `Dockerfile`.
>
> The rest of the keys defines the configuration of a new container `example-persisting-firefox-using-binds`, which will be created and started detached in the background.
>
> The Firefox profile will be persisted in the folder `$HOME/compose-samples/firefox-profile` on the host computer.
>
> The folder `$HOME/compose-samples/Downloads` on the host computer will be bound to the folder `/home/headless/Downloads` in the container.

{: .warning}
> Depending on your environment and configuration you may need to create the folders `$HOME/compose-samples/firefox-profile` and `$HOME/compose-samples/Downloads` yourself before starting the service.

{: .important}
> If you are on Linux with `Docker Desktop for Linux` installed, then you should be aware of [this pitfall][this-pitfall-docker-desktop-for-linux-changing-ownership].

The service can be started using the following command:

```shell
docker compose --profile firefox-using-binds -f persisting.yml -p example-persisting up -d
```

You can check that the new image has been created:

```shell
{% raw %}docker images --filter=reference='example-persisting:*' --format 'table {{.Repository}}\t{{.Tag}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> REPOSITORY           TAG
> example-persisting   firefox
> </pre>

There should be also the new container running:

```shell
{% raw %}docker container ls --filter 'name=example-persisting' --format 'table {{.Names}}\t{{.Status}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> NAMES                                    STATUS
> example-persisting-firefox-using-binds   Up 2 minutes
> </pre>

### Checking bind mount persistency

Connect to the container as it is described in the section [Headless working][this-headless-working] and start the Firefox browser.
It will create and initialize the Firefox profile.

Then make some changes in Firefox settings that you can later recognize.

You can, for example, change the setting `Homepage and new windows` from its default value `Firefox Home (Default)` to `Blank Page`.

Being *inside* the container, create a new file in the container's folder `/home/headless/Downloads`.

The file should be also seen *outside* the container, in the folder `$HOME/compose-samples/Downloads` on your host computer.

{: .pitfall}
> Now it's already becoming to be challenging, maybe.
> Depending on your environment, you may notice, that the ownership of the host's folder `$HOME/compose-samples/Downloads` has changed.
> You may not be allowed to change the files in it from your host computer.
> Mitigation of this problem caused by `Docker Desktop for Linux` is described [here][this-mitigating-pitfall-docker-desktop-for-linux-changing-ownership].

Now close the Firefox and disconnect from the container.

Then stop the service using the following command:

```shell
docker compose --profile firefox-using-binds -f persisting.yml -p example-persisting down
```

Note that the image and the bound folders on the host computer have not been removed, only the container is gone.
You can verify it using the commands provided above.

Now you can start the service again using the same command as above:

```shell
docker compose --profile firefox-using-binds -f persisting.yml -p example-persisting up -d
```

Only the container will be create as new, the existing image and the folders on the host computer will be re-used.

Now connect to the container again and check and start the Firefox browser.

You should see a blank home page.

Also the file you've created in the container's folder `/home/headless/Downloads` should be still there.

You should be also able to edit the file from *inside* the container.

It proves that the Firefox profile and the created file have been persisted and that they have survived the container re-creation.

You can re-use them until you delete them explicitly.

Similarly you can reuse the created Docker image.

### Removing bind mount assets

You can remove the created image, container and the bound folder on the host computer several ways, using different Docker CLI and system commands.

Using the *Compose* commands you can remove only the image and the container, but not the folders on the host computer.

Removing the container, but keeping the image:

```shell
docker compose --profile firefox-using-binds -f persisting.yml -p example-persisting down
```

Removing the image and container at once:

```shell
docker compose --profile firefox-using-binds -f persisting.yml -p example-persisting down --rmi all
```

You can remove the folder on your host computer using the following command:

```shell
sudo rm -rf $HOME/compose-samples/
```

{: .note}
> Depending on your current environment and permissions you may need elevated permissions (`sudo`) for removing the bound folder on your host computer.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/using-compose/basic-examples/
[this-goto-next-page]: {{site.baseurl}}/using-compose/extending-examples/

[this-using-compose-basic-examples]: {{site.baseurl}}/using-compose/basic-examples/
[this-using-volumes]: {{site.baseurl}}/using-volumes/
[this-using-bind-mounts]: {{site.baseurl}}/using-bind-mounts/
[this-headless-working]: {{site.baseurl}}/headless-working/

[this-pitfall-docker-desktop-for-linux-changing-ownership]: {{site.baseurl}}/using-bind-mounts/#pitfall-docker-desktop-for-linux-changing-ownership

[this-mitigating-pitfall-docker-desktop-for-linux-changing-ownership]: {{site.baseurl}}/using-bind-mounts/#mitigating-pitfall-docker-desktop-for-linux-changing-ownership

[github-accetto-user-guide-g3-examples-compose]: https://github.com/accetto/user-guide-g3/tree/main/examples/compose

[docker-docs-compose-cli]: https://docs.docker.com/compose/reference/

[docker-docs-compose-file-reference]: https://docs.docker.com/compose/compose-file/
