---
layout: default
title: Pitfalls
parent: Remainder
permalink: /pitfalls/
nav_order: "900.20"
---

# List of pitfalls
{: .fs-9 }

in one place
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Concise list of pitfalls described in this *User guide*.

{% include components/collapsible-toc.md %}

## Using containers

### Skipping startup script

If you will skip the *container startup script*, then the container environment will not be fully configured.

Read more about this pitfall [here][this-pitfall-skipping-startup-script].

### WebGL disabled or unavailable

If you often visit web sites that require WebGL, then you may notice, that not all web browser images fully support WebGL by default.

It is not a bug, but a compromise decision favouring smaller image sizes over WebGL support.

Read more about it [here][this-webgl-support].

### Crashing applications

If applications are crashing, you may need to increase the shared memory (SHM) size.

Read more about it [here][this-shared-memory].

## Keeping data

### Using bind mounts for $HOME

Learn [here][this-pitfall-home-binding] why you should avoid using *bind mounts* for the whole `$HOME` directory.

### Docker Desktop for Linux changes ownership

If you're on Linux and you have `Docker Desktop for Linux` installed, then read about [this pitfall][this-pitfall-docker-desktop-changing-ownership].

## Extending images

### Failing startup

If you've extended an *accetto image* and your container fails to start, then you may have the problem described [here][this-pitfall-extending-images-and-failing-startup].

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/remainder/
[this-goto-next-page]: {{site.baseurl}}/repositories/

[this-webgl-support]: {{site.baseurl}}/webgl-support/

[this-shared-memory]: {{site.baseurl}}/shared-memory/

[this-pitfall-skipping-startup-script]: {{site.baseurl}}/container-startup/#pitfall-skipping-startup-script

[this-pitfall-home-binding]: {{site.baseurl}}/using-bind-mounts/#pitfall-home-binding

[this-pitfall-docker-desktop-changing-ownership]: {{site.baseurl}}/using-bind-mounts/#pitfall-docker-desktop-for-linux-changing-ownership

[this-pitfall-extending-images-and-failing-startup]: {{site.baseurl}}/using-compose/extending-examples/#pitfall-extending-images-and-failing-startup
