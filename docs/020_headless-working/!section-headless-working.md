---
layout: default
title: Headless working
has_children: true
nav_order: "020"
permalink: /headless-working/
---

# Headless working
{: .fs-9 }

over VNC or noVNC
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
This section describes how to use *accetto containers* for *headless working* with common web browsers or VNC viewers.

{: .highlight}
> *Headless working* for the purpose of this *User guide* means that you can work with GUI applications over network, without having physical access to the input and output devices of the computer, where the applications are actually running.

<!-- {: .note} -->
> Running *accetto containers* on your local host computer is only a particular case of this broader definition.

All *accetto containers* can be used for *headless working* with common web browsers or VNC viewers, because they all include [TigerVNC][tigervnc] server and [noVNC][novnc] client.

Working headless with VNC viewers or web browsers is a question of personal preference and also of technical constraints.
You can, for example, prefer VNC viewers (`VNC`) on local environments and web browsers (`noVNC`) for remote access.

{: .note}
> Even if this section describes the two scenarios separately, all *accetto containers* expose both TCP ports and they can be accessed with both web browsers and VNC viewers simultaneously.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/image-family/
[this-goto-next-page]: {{site.baseurl}}/using-novnc/

[this-extending-images]: {{site.baseurl}}/extending-images/

[accetto-github]: https://github.com/accetto
[accetto-dockerhub]: https://hub.docker.com/u/accetto/

[novnc]: https://github.com/novnc/noVNC
[tigervnc]: http://tigervnc.org
[tightvnc]: http://www.tightvnc.com
