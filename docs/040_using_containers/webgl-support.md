---
layout: default
title: WebGL support
parent: Using containers
permalink: /webgl-support/
nav_order: "040.090"
---

# WebGL support
{: .fs-9 }

in web browsers
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Some *accetto images* have limited WebGL support in web browsers.
It is not a bug, but a compromise decision favouring smaller image sizes over WebGL support.

{% include components/collapsible-toc.md %}

Generally it's not a problem, but if you often visit web sites that require WebGL, then you have the following options:

1. You can choose a browser image that already supports WebGL (see below)
2. You can install the package `mesa-utils` yourself

In some cases WebGL support comes with the web browser package itself.

## Current WebGL support status

The current status of WebGL support in the *accetto images* with web browsers is summarized in the following table:

| Image                                         | WebGL |
| :-------------------------------------------- | :---: |
| Based on Ubuntu, Firefox browser              |  no   |
| Based on Ubuntu, Chromium browser             |  yes  |
| Based on Debian, Firefox browser              |  no   |
| Based on Debian, Chromium browser             |  no   |
| Based on Ubuntu with Mesa3D, Firefox browser  |  yes  |
| Based on Ubuntu with Mesa3D, Chromium browser |  yes  |

## Testing WebGL support

You can test for the WebGL support in a running container by visiting the official [WebGL test page][webgl-test-page].

If the web browser supports WebGL, then you should see a spinning cube.

The following animation illustrates both possible cases.

![animation WebGL test page][this-animation-webgl-test-page]

## Installing WebGL support

If you decide to install the package `mesa-utils` yourself, then you can do it using the following command:

```shell
sudo apt-get update && sudo apt-get install -y mesa-utils
```

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/shared-memory/
[this-goto-next-page]: {{site.baseurl}}/firefox-plus/

[this-animation-webgl-test-page]: {{site.baseurl}}/assets/images/animation-webgl-test-page.gif

[webgl-test-page]: https://get.webgl.org/
