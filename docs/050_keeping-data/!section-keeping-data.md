---
layout: default
title: Keeping data
has_children: true
nav_order: "050"
permalink: /keeping-data/
---

# Keeping data
{: .fs-9 }

between container sessions
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
This section describes how to keep data between container sessions and how to avoid some pitfalls.

[Docker Docs: Manage data in Docker][docker-docs-storage]{: .btn .fs-2 }

Generally there are two approaches:

1. Keeping data [*inside*][this-data-inside] containers
2. Keeping data *outside* containers
   1. in [volumes][this-using-volumes]
   2. in [bind mounts][this-using-bind-mounts]

{: .important}
> Before persisting data outside the container, you should read the section [Manage data in Docker][docker-docs-storage] in the official Docker documentation.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/version-sticker/
[this-goto-next-page]: {{site.baseurl}}/data-inside/

[this-data-inside]: {{site.baseurl}}/data-inside/
[this-using-volumes]: {{site.baseurl}}/using-volumes/
[this-using-bind-mounts]: {{site.baseurl}}/using-bind-mounts/

[docker-docs-storage]: https://docs.docker.com/storage/
