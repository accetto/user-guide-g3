---
layout: default
title: Using Compose
has_children: true
nav_order: "060"
permalink: /using-compose/
---

# Using Compose
{: .fs-9 }

for creating *accetto containers*
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
This sections contains examples of creating *accetto containers* using Docker Compose.

[Docker Docs: Compose CLI][docker-docs-compose-cli]{: .btn .fs-2 }
[Docker Docs: Compose file reference][docker-docs-compose-file-reference]{: .btn .fs-2 }
[Examples: Compose][github-accetto-user-guide-g3-examples-compose]{: .btn .fs-2 }

All example resources are contained in the folder `/examples/` of the GitHub project [accetto/user-guide-g3][github-accetto-user-guide-g3].

For simplicity, some example containers may re-use the same *TCP port bindings*.

If you want tu run several example containers simultaneously, you may need to adjust the port bindings or to use the automatic TCP port assignment provided by Docker CLI.

The default VNC/noVNC connection password is `headless`.
The default container user password and the `sudo` password is also `headless`.

The service definitions in the *Compose files* use explicit names for the images they build and the containers they create.
That is technically not necessary, but it helps to simplify the Docker CLI command examples.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/using-bind-mounts/
[this-goto-next-page]: {{site.baseurl}}/using-compose/common-assets/

[github-accetto-user-guide-g3]: https://github.com/accetto/user-guide-g3

[github-accetto-user-guide-g3-examples-compose]: https://github.com/accetto/user-guide-g3/tree/main/examples/compose

[docker-docs-compose-cli]: https://docs.docker.com/compose/reference/

[docker-docs-compose-file-reference]: https://docs.docker.com/compose/compose-file/
