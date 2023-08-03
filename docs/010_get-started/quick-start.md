---
layout: default
title: Quick start
parent: Get started
permalink: /quick-start/
nav_order: "010.30"
---

# Quick start
{: .fs-9 }

with *accetto image family*
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
If you already have a working [Docker][docker] environment and a common web browser, then you can start with [*headless working*][this-headless-working] right away.

Let's create your first *accetto container* and call it `quick`:

```shell
docker run -d -p "36901:6901" --name quick --hostname quick accetto/ubuntu-vnc-xfce-g3
```

{: .note}
> The first time it'll take a minute, because the Docker image must be pulled from the Docker Hub repository.

The container will keep running in the background and you can connect to it using your web browser on the following URL:

```text
http://localhost:36901
```

Please choose the `noVNC Lite Client` hyperlink and use the connection password `headless`.

That's actually all to it.
Quick and easy.

The following animation illustrates the expected experience.

![animation novnc-lite connect][this-animation-novnc-lite-connect]

{: .highlight}
You can find more information in the section [Headless working][this-headless-working].

The created container can be removed using the following command:

```shell
docker rm -f quick
```

The pulled image can be removed using the following command:

```shell
docker rmi accetto/ubuntu-vnc-xfce-g3
```

{: .tip}
> You can try also other images from the [*accetto image family*][this-image-family].

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/features/
[this-goto-next-page]: {{site.baseurl}}/image-family/

[this-image-family]: {{site.baseurl}}/image-family/

[this-headless-working]: {{site.baseurl}}/headless-working/

[this-animation-novnc-lite-connect]: {{site.baseurl}}/assets/images/novnc-lite-connect.gif

[docker]: https://www.docker.com/
