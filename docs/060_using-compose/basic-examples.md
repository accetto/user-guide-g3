---
layout: default
title: Basic examples
parent: Using Compose
permalink: /using-compose/basic-examples/
nav_order: "060.20"
---

# Examples of services
{: .fs-9 }

that keep data inside containers
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Examples in this chapter create containers that keep data inside themselves.

[Docker Docs: Compose CLI][docker-docs-compose-cli]{: .btn .fs-2 }
[Docker Docs: Compose file reference][docker-docs-compose-file-reference]{: .btn .fs-2 }
[Examples: Compose][github-accetto-user-guide-g3-examples-compose]{: .btn .fs-2 }

The images and containers are created or deleted by the services defined in the common *Compose file* called `basic.yml`.

It's assumed that the *current directory* is the one which contains the *Compose files*.

{% include components/collapsible-toc.md %}

### Starting all services at once

You can start all services at once using the following command:

```shell
docker compose --profile all -f basic.yml -p example-basic up -d
```

{: .explain}
> The `--profile` parameter defines the profile value.
> Only the services belonging to this profile will be processed.
> The value `all` will include all services, because they all declare this profile value.
>
> The `-f` parameter defines the name of the *Compose file* to use.
>
> The `-p` parameter defines the name of the *Compose project*, which is also called *Compose application*.
>
> The `up` command will start up the services.
>
> The `-d` parameter means that the service containers should keep running detached in the background.

{: .note}
> The first start up may take some time, because the base images must be pulled from the Docker Hub repositories.

All created images will be called `example-basic`, but their tags will be different.

You can check it using the following command:

```shell
{% raw %}docker images --filter=reference='example-basic:*' --format 'table {{.Repository}}\t{{.Tag}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> REPOSITORY      TAG
> example-basic   opengl
> example-basic   ubuntu
> example-basic   debian
> </pre>

There will be also new containers running.
Their names will begin with `example-basic-`, followed by the service name.

You can check it using the following command:

```shell
{% raw %}docker container ls --filter 'name=example-basic' --format 'table {{.Names}}\t{{.Status}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> NAMES                  STATUS
> example-basic-opengl   Up 30 seconds
> example-basic-debian   Up 30 seconds
> example-basic-ubuntu   Up 30 seconds
> </pre>

## Stopping all services at once

You can shut down all services at once and remove all created assets using the following command:

```shell
docker compose --profile all -f basic.yml -p example-basic down --volumes --rmi all
```

{: .explain}
> The `--profile` parameter defines the profile value.
> Only the services belonging to this profile will be processed.
> The value `all` will include all services, because they all declare this profile value.
>
> The `-f` parameter defines the name of the *Compose file* to use.
>
> The `-p` parameter defines of the *Compose project*, which is also called *Compose application*.
>
> The `down` command will shut down the services.
>
> The `--volumes` parameter means, that the services should remove all the volumes declared in the 'volumes' section of the *Compose file* and all anonymous volumes attached to the containers.
>
> **Warning** Be careful with the `--volumes` parameter because you can delete your data unintentionally!
>
> The `--rmi all` parameter means that the services should remove all the images they have created.

## Starting individual services

You can start a particular service by providing the appropriate `profile` value.

The following fragment of the sample *Compose file* `basic.yml` defines the service `ubuntu`, which creates a new Ubuntu based image and container:

```yaml
services:
  ubuntu:
    profiles:
      - all
      - ubuntu
    build:
      context: ./docker
      dockerfile: Dockerfile
      target: stage_basic-ubuntu
    image: example-basic:ubuntu
    container_name: example-basic-ubuntu
    hostname: example-basic-ubuntu
    shm_size: "256m"
    environment:
      - VNC_RESOLUTION=1024x768
    ports:
      - "45901:5901"  # VNC
      - "46901:6901"  # noVNC
```

{: .explain}
> Key `profiles`: The service is part of the profiles `all` and `ubuntu`.
>
> Key `build`: A new image `example-basic:ubuntu` is built from the stage `stage_basic-ubuntu` of the `Dockerfile`.
>
> The rest of the keys defines the configuration of a new container `example-basic-ubuntu`, which will be created and started detached in the background.

You can start the service using the following command:

```shell
docker compose --profile ubuntu -f basic.yml -p example-basic up -d
```

You can check that only a single new images has been created:

```shell
{% raw %}docker images --filter=reference='example-basic:*' --format 'table {{.Repository}}\t{{.Tag}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> REPOSITORY      TAG
> example-basic   ubuntu
> </pre>

Also only a single new container has been started:

```shell
{% raw %}docker container ls --filter 'name=example-basic' --format 'table {{.Names}}\t{{.Status}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> NAMES                  STATUS
> example-basic-ubuntu   Up 3 minutes
> </pre>

You can connect to the container as it's described in the section [Headless working][this-headless-working] and check that also the [common assets][this-using-compose-common-assets] have been applied.

The following animation shows how to check the user profile customization.

![Basic Ubuntu container][this-animation-compose-example-basic-ubuntu]

You can also check that the following keyboard layouts have been configured:

- English (US)
- German
- Italian
- Spanish

## Stopping individual services

You can stop and remove the basic Ubuntu container created above using the following command:

```shell
docker compose --profile ubuntu -f basic.yml -p example-basic down --volumes --rmi all
```

The related image will be also removed, unless it's used by some other container.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/using-compose/common-assets/
[this-goto-next-page]: {{site.baseurl}}/using-compose/persisting-examples/

[this-headless-working]: {{site.baseurl}}/headless-working/
[this-using-compose-common-assets]: {{site.baseurl}}/using-compose/common-assets/

[this-animation-compose-example-basic-ubuntu]: {{site.baseurl}}/assets/images/animation-compose-example-basic-ubuntu.gif

[github-accetto-user-guide-g3-examples-compose]: https://github.com/accetto/user-guide-g3/tree/main/examples/compose

[docker-docs-compose-cli]: https://docs.docker.com/compose/reference/

[docker-docs-compose-file-reference]: https://docs.docker.com/compose/compose-file/
