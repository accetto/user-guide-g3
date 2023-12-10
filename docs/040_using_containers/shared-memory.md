---
layout: default
title: Shared memory
parent: Using containers
permalink: /shared-memory/
nav_order: "040.080"
---

# Shared memory
{: .fs-9 }

and how to configure it
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Containers with applications often require larger *shared memory* than the Docker's default of 64MB.

Experience shows, that 256MB is usually enough in most cases.

You can increase the *shared memory* (`SHM`) size of individual containers or you can change the Docker's default value.

{% include components/collapsible-toc.md %}

## Checking current SHM size

You can check the current `SHM` size *inside* a running container by executing the following command:

```shell
df -h /dev/shm
```

{% include components/callout-terminal.md %}
> <pre>
> Filesystem      Size  Used Avail Use% Mounted on
> shm             256M     0  256M   0% /dev/shm
> </pre>

## Setting SHM using Docker CLI

The `SHM` size is set by container creation.

For example, the following command fragment shows how to set the `SHM` size to 256MB:

```shell
docker run --shm-size=256m ...
```

## Setting SHM using Docker Compose

The `SHM` size is set in the service configuration.

If the service builds a new image, then you can set the default SHM size for the image during its build time.

You can also set the SHM size for the run time of the service container.

For example, the following compose file fragment shows, how to set the `SHM` size to 256MB for the built image and to 512MB for the created container:

```yaml
services:
  some_service:
    build:
      context: .
      shm_size: '256m'  ## image build time
      ...
    shm_size: '512m'    ## container run time
    ...
```

## Setting default SHM size on Linux

If you are on Linux and you don't have the `Docker Desktop for Linux` installed, then you can change the default `SHM` size by changing the value of the parameter `default-shm-size` in the file `/etc/docker/daemon.json`.

If the file does not exist yet, then create it first.

For example, changing the `SHM` size to 256MB:

```json
{
  "default-shm-size": "256m"
}
```

After modifying the file you have to restart the Docker service:

```shell
sudo systemctl restart docker
```

## Setting default SHM size in Docker Desktop

If you have *Docker Desktop* installed (on Windows or Linux), then you can change the default `SHM` size by changing the value of the parameter `default-shm-size` in the `Docker Engine` configuration.

For example, changing the `SHM` size to 256MB:

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "default-shm-size": "256M",
  "experimental": false
}
```

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/installing-packages/
[this-goto-next-page]: {{site.baseurl}}/webgl-support/
