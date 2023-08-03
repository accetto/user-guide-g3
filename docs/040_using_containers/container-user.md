---
layout: default
title: Container user
parent: Using containers
permalink: /container-user/
nav_order: "040.030"
---

# Container user
{: .fs-9 }

parameters and password
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
The container user is a *non-root* user.
However, the account is added into the `sudo` group *inside* the container.

{% include components/collapsible-toc.md %}

The default *container user* has the following parameters:

- user ID is `1000`
- user name is `headless`
- user group ID is `1000`
- user group name is `headless`
- user home directory is `/home/headless/`
- user password is `headless`
- user default shell is `bash`

### Using sudo

The `sudo` command allows user elevation, therefore the container user can install additional software *inside* the container.

For example, this is how you can install the `vim` editor *inside* the container:

```shell
sudo apt-get update
sudo apt-get install -y vim
```

{: .important}
> The default container user password and the `sudo` password is `headless`.

{: .note}
> Please do not confuse the *container user password* with the *VNC/noVNC connection password*.
> These are two different passwords even if they are both set to `headless` by default.

### Changing user password

The container user password can be changed *inside* the container.

For example, if you want to set the password to `docker`, you can use the following commands:

```shell
echo 'headless:docker' | sudo chpasswd
```

or also

```shell
sudo chpasswd <<<"headless:docker"
```

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/startup-help/
[this-goto-next-page]: {{site.baseurl}}/overriding-user/
