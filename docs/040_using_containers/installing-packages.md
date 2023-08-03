---
layout: default
title: Installing packages
parent: Using containers
permalink: /installing-packages/
nav_order: "040.070"
---

# Installing packages
{: .fs-9 }

in running containers
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Installing packages inside running *accetto containers* is fairly simple.
The container user is a member of `sudo` group and therefore you can install new packages the usual way.

{% include components/collapsible-toc.md %}

You should always start by refreshing the list of available packages by executing the following command *inside* the container:

```shell
sudo apt-get update
```

The `sudo` command will ask for the container user password, which is `headless` by default.

Note that the `sudo` authorization will expire after some time and you'll be asked for the password again.

New packages are installed using the `apt-get install` command.

For example, if you want to install the popular text editor `Vim`:

```shell
sudo apt-get install -y vim
```

You can verify that `Vim` has been installed by using the following command:

```shell
which vim
```

{% include components/callout-terminal.md %}
> /usr/bin/vim

You will find the `Vim` launcher in the `Applications/Accessories` menu.

## Fixing broken dependencies

Almost all packages depend on other packages.

The `apt-get install` command usually handles all dependencies automatically, but sometimes it can happen, that something goes wrong.

The following command could help in such cases:

```shell
sudo apt --fix-broken install
```

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/overriding-vnc/
[this-goto-next-page]: {{site.baseurl}}/shared-memory/
