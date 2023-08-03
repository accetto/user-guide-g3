---
layout: default
title: Features
parent: Get started
permalink: /features/
nav_order: "010.20"
---

# Features
{: .fs-9 }

of *accetto images*
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
All *accetto images* offer additional features that are not commonly provided by Docker images.
Some of them are unique to the *accetto image family*.

{% include components/collapsible-toc.md %}

## Additional features

The most notable additional features are probably the ones supporting [headless working][this-headless-working]:

1. Graphical [Xfce][xfce] desktop environment
2. Access over [noVNC][novnc] with common web browsers
3. Access over VNC with common VNC viewers
4. Popular web browsers [Firefox][firefox] and [Chromium][chromium]
5. Support of [sudo][sudo] command
6. Set of popular Linux utilities and applications
7. Support of [Mesa3D][mesa3d] and [VirtualGL][virtualgl] (some images)

## Unique features

There are also additional features that are unique to the *accetto image family*.
They have been introduced and developed by *accetto*.

### Features as a concept

The first unique feature is called *Features* (no pun intended).

The *concept of features* has been introduced in the third generation (G3) of *accetto images*.

{: .definition}
> The features are any properties of a Docker image, that have some significance for the developer or the user of the image.
> For example, *slim build* or *novnc included* could be features.
>
> The *features* are expressed as variables in the source code.
> The *feature variables* could be translated to *build arguments*.
> The *feature variables* set in Dockerfiles are persisted in the images as environment variables.

The features in this meaning are relevant mostly for image building, which lies outside the scope of this *User guide*.

However, there can be also features, that control container run-time behavior.

For example, the feature [Overriding ENVV][this-overriding-envv] controls the possibility to override environment variables at the container startup-time.

### Version sticker

The [Version sticker][this-version-sticker] feature allows to quickly determine the *feature set* of the particular container build.

Version stickers play an important role in image building, which lies outside the scope of this *User guide*.

### Firefox Plus

The [Firefox Plus][this-firefox-plus] feature makes enforcing of personal Firefox browser preferences more convenient.

### Overriding ENVV

The [Overriding ENVV][this-overriding-envv] feature allows to override environment variables at the container startup-time (after the container has been already created).

### Overriding VNC

The [Overriding VNC][this-overriding-vnc] feature allows to override the VNC/noVNC parameters at the container startup-time (after the container has been already created).

### Overriding user and group

The [Overriding user and group][this-overriding-user] feature enhances the default overriding support from Docker.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/requirements/
[this-goto-next-page]: {{site.baseurl}}/quick-start/

[this-firefox-plus]: {{site.baseurl}}/firefox-plus/
[this-headless-working]: {{site.baseurl}}/headless-working/
[this-version-sticker]: {{site.baseurl}}/version-sticker/
[this-overriding-user]: {{site.baseurl}}/overriding-user/
[this-overriding-envv]: {{site.baseurl}}/overriding-envv/

[this-overriding-vnc]: {{site.baseurl}}/overriding-vnc/#overriding-at-container-startup-time

[accetto-github]: https://github.com/accetto
[accetto-dockerhub]: https://hub.docker.com/u/accetto/

[chromium]: https://www.chromium.org/Home
[firefox]: https://www.mozilla.org
[mesa3d]: https://mesa3d.org/
[novnc]: https://github.com/kanaka/noVNC
[sudo]: https://www.sudo.ws/
[tigervnc]: http://tigervnc.org
[virtualgl]: https://virtualgl.org/
[xfce]: http://www.xfce.org
