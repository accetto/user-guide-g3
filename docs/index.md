---
layout: home
title: Home
nav_order: 10
description: User Guide | How to use Docker images from accetto.
permalink: /
---

# User guide
{: .fs-9 }

for Docker images from *accetto*
{: .fs-6 .fw-300 }

![badge-github-user-guide-g3-release][badge-github-user-guide-g3-release]
![badge-github-user-guide-g3-last-commit][badge-github-user-guide-g3-last-commit]

<!-- ![badge-github-user-guide-g3-actions-workflow-status][badge-github-user-guide-g3-actions-workflow-status] -->
<!-- ![badge-github-user-guide-g3-jekyll-deploy-status][badge-github-user-guide-g3-jekyll-deploy-status] -->

{% include components/buttons-view-it-on.md %}

{: .fs-5 .fw-300 }
This *User guide* describes a selection of [Docker][docker] images that are part of [open-source projects][accetto-github] from *accetto*.
This selection will be called throughout this documentation as *accetto image family* or simply *accetto images*.
The containers created from them will be called *accetto containers*.

The *accetto containers* resemble *virtual machines*, because they provide a complete Linux desktop environment.
Also using them feels quite similar.

Despite of that it should be understood, that Docker containers are technically different from traditional virtual machines.

The *accetto containers* are intended for [headless working][this-headless-working].
They are useful in a wide range of scenarios, from simple disposable web browsers to complex encapsulated development environments.

{: .note}
> This *User Guide* belongs to the **third generation** (G3) of *accetto images*.
> The provided samples and recipes may not work properly with the images from the previous generations G2 and G1.

{: .note}
> All command examples in this *User guide* assume Linux environment.
> It includes also WSL on Windows.

{: .important}
> Please note that [*accetto open source projects*][accetto-github] are provided *for free* and *as is*.
> They are also *work in progress* and they can be changed or cancelled without warning.
> You can use and modify them as you need, but no responsibility can be taken for any harm or damage you suffer or cause.
> Please use them responsibly.
> Note also that any support can be only community based.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/{{permalink}}
[this-goto-next-page]: {{site.baseurl}}/get-started/

[badge-github-user-guide-g3-release]: https://badgen.net/github/release/accetto/user-guide-g3?icon=github&label=release

[badge-github-user-guide-g3-last-commit]: https://badgen.net/github/last-commit/accetto/user-guide-g3?icon=github&label=last%20commit

<!-- [badge-github-user-guide-g3-actions-workflow-status]: https://img.shields.io/github/actions/workflow/status/accetto/user-guide-g3/pages.yml -->

<!-- [badge-github-user-guide-g3-jekyll-deploy-status]: https://github.com/accetto/user-guide-g3/actions/workflows/pages.yml/badge.svg -->

[this-headless-working]: {{site.baseurl}}/headless-working/

[accetto-github]: https://github.com/accetto
[accetto-dockerhub]: https://hub.docker.com/u/accetto/

[docker]: https://www.docker.com/
