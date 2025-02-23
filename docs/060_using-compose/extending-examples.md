---
layout: default
title: Extending examples
parent: Using Compose
permalink: /using-compose/extending-examples/
nav_order: "060.50"
---

# Examples of services
{: .fs-9 }

that create and use extended images
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
Examples in this chapter show services that create containers based on extended *accetto images*.

[Docker Docs: Compose CLI][docker-docs-compose-cli]{: .btn .fs-2 }
[Docker Docs: Compose file reference][docker-docs-compose-file-reference]{: .btn .fs-2 }
[Examples: Compose][github-accetto-user-guide-g3-examples-compose]{: .btn .fs-2 }

The images and containers are created or deleted by the services defined in the common *Compose file* called `extending.yml`.

It's assumed that the *current directory* is the one which contains the *Compose files*.

{% include components/collapsible-toc.md %}

[Compose file reference][docker-docs-compose-file-reference]{: .btn .fs-2 }

## Handling services

The chapter about [basic examples][this-using-compose-basic-examples] describes how to start and stop the services all at once or individually.

You can use the same commands also for these examples, just providing the *Compose file* name `extending.yml` and the appropriate profile name.

## Overriding user, group and variables

This sample service demonstrates how to extend an *accetto image* and to make the following changes:

- override existing environment variables
- add new environment variables
- change the container user UID
- change the container user group GID

The service builds a new extended image `example-extending:overriding-example` from the stage `stage_extending_overriding-example` of the common sample `Dockerfile`.

The following `Dockerfile` fragment shows the used stage:

```Dockerfile
FROM accetto/ubuntu-vnc-xfce-g3:latest as stage_extending_overriding-example

ENV \
    HEADLESS_USER_ID=2000\
    HEADLESS_USER_GROUP_ID=3000 \
    STAGE=development

USER 0

RUN \
    groupmod -g "${HEADLESS_USER_GROUP_ID}" "${HEADLESS_USER_GROUP_NAME}" \
    && usermod -u "${HEADLESS_USER_ID}" -g "${HEADLESS_USER_GROUP_ID}" "${HEADLESS_USER_NAME}"

### Warning! This is required, otherwise there will be the following lines in the container's log:
### mkdir: cannot create directory '/home/headless/.vnc': Permission denied
### /dockerstartup/vnc_startup.rc: line 57: /home/headless/.vnc/passwd: No such file or directory
### chmod: cannot access '/home/headless/.vnc/passwd': No such file or directory
### /dockerstartup/vnc_startup.rc: line 65: /home/headless/.vnc/config: No such file or directory
### /dockerstartup/vnc_startup.rc: line 99: /dockerstartup/vnc.log: Permission denied
RUN chmod 666 /etc/passwd /etc/group

USER "${HEADLESS_USER_ID}":"${HEADLESS_USER_GROUP_ID}"
```

{: .explain}
> `ENV`: Existing variables `HEADLESS_USER_ID` and `HEADLESS_USER_GROUP_ID` are overridden and the new variable `STAGE` is added.
>
> `USER 0`: Root permission are needed for modifying the user and the group.
>
> `RUN`: The user UID and the group GID are set to the new values.
>
> `RUN chmod 666 /etc/passwd /etc/group`: This line is required, otherwise the *startup script* will not be able to complete the container initialization on its first start.
> Note that the permissions of the both system files will be set to the system default values after the container is initialized.
>
> `USER "${HEADLESS_USER_ID}":"${HEADLESS_USER_GROUP_ID}"`: Switching from the `root` to the new non-root container user.

The following fragment of the sample *Compose file* `extending.yml` defines the service `overriding-example`:

```yaml
services:
  overriding-example:
    profiles:
      - all
      - overriding-example
    build:
      context: ./docker
      dockerfile: Dockerfile
      target: stage_extending_overriding-example
    image: example-extending:overriding-example
    container_name: example-extending-overriding-example
    hostname: example-extending-overriding-example
    ports:
      - "45901:5901"  # VNC
      - "46901:6901"  # noVNC
```

{: .explain}
> Element `services` contains the definition of the service service `overriding-example`:
>
> Key `profiles`: The service is part of the profiles `all` and `overriding-example`.
>
> Key `build`: A new image `example-extending:overriding-example` is built from the stage `stage_extending_overriding-example` of the `Dockerfile`.
>
> The rest of the keys defines the configuration of a new container `example-extending-overriding-example`, which will be created and started detached in the background.
>
> The container is accessible with a VNC viewer on the TCP port `45901` and with a web browser on the TCP port `46901`.

Enter the directory containing the compose file `extending.yml` and start the service using the following command:

```shell
docker compose --profile overriding-example -f extending.yml -p example-extending up -d
```

After the service is started, you can check that the new image has been created:

```shell
{% raw %}docker images --filter=reference='example-extending:*' --format 'table {{.Repository}}\t{{.Tag}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> REPOSITORY          TAG
> example-extending   overriding-example
> </pre>

There should also be the new container running:

```shell
{% raw %}docker container ls --filter 'name=example-extending' --format 'table {{.Names}}\t{{.Status}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> NAMES                                  STATUS
> example-extending-overriding-example   Up 2 minutes
> </pre>

Connect to the running container and execute the commands shown in the following terminal window.

Close the interactive session by executing `exit`.

```shell
docker exec -it example-extending-overriding-example bash
```

{% include components/callout-terminal.md %}
> <pre class="fs-2">
> PS1='example$ '
> example$
>
> example$ echo $HEADLESS_USER_ID
> 2000
>
> example$ echo $HEADLESS_USER_GROUP_ID
> 3000
>
> example$ echo $STAGE
> development
>
> example$ id
> uid=2000(headless) gid=3000(headless) groups=3000(headless)
>
> example$ exit
> exit
> </pre>

It can be seen, that the environment variables has been correctly overridden and added and that the current container user has the correct UID and GID.

The container and the image can be removed using the following command:

```shell
docker compose --profile overriding-example -f extending.yml -p example-extending down --rmi all
```

## Jekyll container with VSCode and Firefox

This sample service creates a container for [Jekyll][jekyll] development by using an extended image [accetto/debian-vnc-xfce-vscode-g3:firefox][dockerhub-accetto-debian-vnc-xfce-vscode-g3].

The service builds a new extended image `example-extending:jekyll-vscode-firefox` from the stage `stage_extending_jekyll-vbuildsscode-firefox` of the common sample `Dockerfile`.

The container uses Docker [volumes][this-using-volumes] for persisting its data.
It's the easiest and the most versatile way that works across all environments.

{: .note}
> This container is almost identical to the one that was used for developing this *User guide*.

The following `Dockerfile` fragment shows the used stage:

```Dockerfile
FROM accetto/debian-vnc-xfce-vscode-g3:firefox as stage_extending_jekyll-vscode-firefox
USER 0
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        locales \
        ruby-full \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*
ENV \
    GEM_HOME="${HOME}/gems" \
    LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LC_MESSAGES=POSIX
COPY ./src/home "${HOME}"/
COPY ./src/firefox.plus/user.js "${HOME}/firefox.plus"/
RUN \
    mkdir -p "${GEM_HOME}" \
    && chown -R "${HEADLESS_USER_ID}":"${HEADLESS_USER_GROUP_ID}" "${GEM_HOME}" \
    && bash -c 'echo -e "\nexport PATH=${GEM_HOME}/bin:${PATH}"' >> "${HOME}"/.bashrc
USER "${HEADLESS_USER_ID}"
RUN gem install --no-document jekyll bundler
```

{: .explain}
> `USER 0`: Root permission are needed for installing additional packages.
>
> `RUN`: Locale is set to `en_US` and `ruby` package is installed.
>
> `ENV`: Required environment variables for locales and `ruby` are set.
>
> `COPY`: Common assets are added.
>
> `RUN`: Folder for Ruby gems is created and the container user is set as its owner.
> The path is prepended to the `PATH` variable value.
>
> `USER ${HEADLESS_USER_ID}`: Switching from the `root` to the non-root container user.
>
> `RUN`: Ruby gems `Bundler` and `Jekyll` are installed.

{: .note}
> Building the extended image can take some time.
> Don't be impatient and don't interrupt the building prematurely.

The following fragment of the sample *Compose file* `extending.yml` defines the service `jekyll-vscode-firefox`:

```yaml
services:
  jekyll-vscode-firefox:
    profiles:
      - all
      - jekyll-vscode-firefox
    build:
      context: ./docker
      dockerfile: Dockerfile
      target: stage_extending_jekyll-vscode-firefox
    image: example-extending:jekyll-vscode-firefox
    container_name: example-extending-jekyll-vscode-firefox
    hostname: example-extending-jekyll-vscode-firefox
    shm_size: "256m"
    environment:
      - VNC_RESOLUTION=1024x768
    ports:
      - "44002:4000"  # jekyll
      - "45902:5901"  # VNC
      - "46902:6901"  # noVNC
    volumes:
      - type: volume
        source: jekyll-firefox-profile
        target: /home/headless/.mozilla/firefox
      - type: volume
        source: jekyll-vscode-config
        target: /home/headless/.config/Code
      - type: volume
        source: jekyll-vscode-extensions
        target: /home/headless/.vscode/
      - type: volume
        source: jekyll-gems
        target: /home/headless/gems
      - type: volume
        source: jekyll-projects
        target: /home/headless/projects
volumes:
  jekyll-firefox-profile:
  jekyll-vscode-config:
  jekyll-vscode-extensions:
  jekyll-gems:
  jekyll-projects:
```

{: .explain}
> Element `services` contains the definition of the service service `jekyll-vscode-firefox`:
>
> Key `profiles`: The service is part of the profiles `all` and `jekyll-vscode-firefox`.
>
> Key `build`: A new image `example-extending:jekyll-vscode-firefox` is built from the stage `stage_extending_jekyll-vscode-firefox` of the `Dockerfile`.
>
> The rest of the keys defines the configuration of a new container `example-extending-jekyll-vscode-firefox`, which will be created and started detached in the background.
>
> The container is accessible with a VNC viewer on the TCP port `45902` and with a web browser on the TCP port `46902`.
>
> The Jekyll website is accessible on the TCP port `4000` from *inside* the container and on the port `44002` from *outside* the container.
>
> Element `volumes`:
>
> The Firefox profile will be persisted in the named Docker volume `jekyll-firefox-profile`.
>
> The two Visual Studio Code profile parts will be persisted in the volumes `jekyll-vscode-config` and `jekyll-vscode-extensions`.
>
> The Ruby gems will be stored in the volume `jekyll-gems`.
>
> The volume `jekyll-projects` is intended for persisting the projects.

Enter the directory containing the compose file `extending.yml` and start the service using the following command:

```shell
docker compose --profile jekyll-vscode-firefox -f extending.yml -p example-extending up -d
```

{: .note}
> Starting the service takes some time, because the base image must be pulled from Docker Hub, then extended and then the `Bundler`, `Jekyll` and other gems must be installed and configured.

After the service is started, you can check that the new image has been created:

```shell
{% raw %}docker images --filter=reference='example-extending:*' --format 'table {{.Repository}}\t{{.Tag}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> REPOSITORY          TAG
> example-extending   jekyll-vscode-firefox
> </pre>

There should also be the new container running:

```shell
{% raw %}docker container ls --filter 'name=example-extending' --format 'table {{.Names}}\t{{.Status}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> NAMES                                     STATUS
> example-extending-jekyll-vscode-firefox   Up 9 seconds
> </pre>

Finally, there should be the new named volumes:

```shell
{% raw %}docker volume ls -f name='example-extending' --format '{{.Name}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> example-extending_jekyll-firefox-profile
> example-extending_jekyll-gems
> example-extending_jekyll-projects
> example-extending_jekyll-vscode-config
> example-extending_jekyll-vscode-extensions
> </pre>

### Jekyll website exercise

Let's test the container.
The changes you'll make will be later used for checking the persistency.

Connect to the running container as it is described in the section [Headless working][this-headless-working].

{: .tip}
> You can also optionally pre-configure the Firefox preferences, as it is described in the chapter about the [Firefox Plus feature][this-firefox-plus].

Open the *Visual Studio Code* and change at least one setting from its default value.
It will allow you to check the persistency.
Also install at least one *Visual Studio Code Extension* for the same reason.

Open a new *Visual Studio Code* terminal window (`Terminal/New Terminal`) and change the current folder:

```shell
cd /home/headless/projects
```

{: .tip}
> You can get more space in the terminal window by using the alias `ps1`, which is part of the [common assets][this-using-composecommon-assets-user-profile].

Still in the *Visual Studio Code* terminal window, clone the GitHub project [just-the-docs-template][github-repo-just-the-docs-template]:

```shell
git clone https://github.com/just-the-docs/just-the-docs-template.git
```

In *Visual Studio Code*, open the folder `/home/headless/projects/just-the-docs-template` by using the main menu command `File/Open Folder...`. Choose to trust the project.

In the *Visual Studio Code Explorer* select any file (e.g. `Gemfile`) and from the right-click context menu select the command `Open in Integrated Terminal`. Use the `ps1` alias to make the prompt text shorter.

{% include components/callout-terminal.md %}
> just-the-docs-template>

In the VSCode's terminal window, install the Ruby gems defined in the `Gemfile`:

```shell
bundle install
```

Still in *Visual Studio Code* terminal window, start the Jekyll's built-in web server:

```shell
bundle exec jekyll serve
```

Inside the container, start the Firefox browser and navigate to the URL `http://localhost:4000`.
Bookmark this URL.

You should see the fully functional web page `Just the Docs Template`, which is running locally in the container.

Now you can close the Firefox browser, stop the Jekyll's web server by pressing `CTRL-c`, close the *Visual Studio Code* window and disconnect from the container.

### Accessing jekyll website from outside

If you want to access the jekyll website from *outside* the container, you have to make sure that the service listens on the exposed TCP port on all network interfaces.

Executed the following command *inside* the container:

```shell
bundle exec jekyll serve -H 0.0.0.0
```

Then start the web browser on your host computer (*outside* the container) and navigate to the URL `http://localhost:44002`.

You should see the fully functional web page `Just the Docs Template`, which is running *inside* the container.

{: .tip}
> During development you should start the Jekyll web service *inside* the container using the command `bundle exec jekyll serve --livereload --force_polling -H 0.0.0.0`.
> The website will be then automatically refreshed each time you save the changes.

### Jekyll container persistency check

For checking the persistency, you have first to remove the container *without removing the volumes*.

You can do it by stopping the service using the following command:

```shell
docker compose --profile jekyll-vscode-firefox -f extending.yml -p example-extending down
```

You can verify that the container has been removed by using the same command as above:

```shell
{% raw %}docker container ls --filter 'name=example-extending' --format 'table {{.Names}}\t{{.Status}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> NAMES                                     STATUS
> </pre>

The volumes, on the other hand, should be still there:

```shell
{% raw %}docker volume ls -f name='example-extending' --format '{{.Name}}'{% endraw %}
```

{% include components/callout-terminal.md %}
> <pre>
> example-extending_jekyll-firefox-profile
> example-extending_jekyll-gems
> example-extending_jekyll-projects
> example-extending_jekyll-vscode-config
> example-extending_jekyll-vscode-extensions
> </pre>

Now create a new container by starting the same service again, using the same command as above:

```shell
docker compose --profile jekyll-vscode-firefox -f extending.yml -p example-extending up -d
```

Connect to the container and check that

- *Visual Studio Code* settings you've changed from their default values are still changed
- *Visual Studio Code* extensions you've installed are still there
- Project `just-the-docs-template` is still there and ready to go
- Firefox profile and the bookmark are still there

### Removing Jekyll example assets

You can remove the created image, container and volumes several ways, using different Docker CLI commands.

You can also use the following *Compose* commands.

Removing the container, but keeping the image and the volumes:

```shell
docker compose --profile jekyll-vscode-firefox -f extending.yml -p example-extending down
```

Removing the container and the volumes, but keeping the image:

```shell
docker compose --profile jekyll-vscode-firefox -f extending.yml -p example-extending down --volumes
```

Removing the image, container and volume at once:

```shell
docker compose --profile jekyll-vscode-firefox -f extending.yml -p example-extending down --volumes --rmi all
```

## Pitfall `Extending images and failing startup`

{: .pitfall}
> <span class="text-delta">
> Extending images and failing startup
> <br/>
> </span>
> By extending *accetto images* can sometimes happen, that some packages you've installed, have restored the permissions of the system files `/etc/passwd` or `/etc/group` to their default values.
> This creates a problem for the *container startup script*, which is finalizing the container user and the user group during the *first container start*.
> Read more about it in the chapter about [Container startup][this-container-startup].

For example, the package `software-properties-common` will modify the file `/etc/group` and reset its permissions.

If you've got this kind of problem, the container created from the extended image will not start and you'll see the following errors in its log:

```text
mkdir: cannot create directory '/home/headless/.vnc': Permission denied
/dockerstartup/vnc_startup.rc: line 72: /home/headless/.vnc/passwd: No such file or directory
chmod: cannot access '/home/headless/.vnc/passwd': No such file or directory
/dockerstartup/vnc_startup.rc: line 80: /home/headless/.vnc/config: No such file or directory
dockerstartup/vnc_startup.rc: line 142: /dockerstartup/novnc.log: Permission denied
/dockerstartup/vnc_startup.rc: line 114: /dockerstartup/vnc.log: Permission denied
/dockerstartup/startup.sh: line 25: kill: (19) - No such process
```

## Avoiding pitfall `Extending images and failing startup`

It's possible to avoid the pitfall if you allow the *container startup script* to finish its job during the *first container start*.

The following fragment from the common `Dockerfile` shows how to fix the problem:

```Dockerfile
FROM accetto/ubuntu-vnc-xfce-g3:latest as stage_extending_fixing-pitfall-one
USER 0
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y --no-install-recommends \
        software-properties-common \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

### FIX
RUN chmod 666 /etc/passwd /etc/group

USER "${HEADLESS_USER_ID}"
```

{: .important}
> The permissions of the system files `/etc/passwd` and `/etc/group` will be set to the system default values by the *container startup script* on the *first container start*.

{: .tip}
> You will do nothing wrong, if you will include the fixing line `RUN chmod 666 /etc/passwd /etc/group` into each extending Dockerfile.

The following fragment from the common *Compose file* `extending.yml` shows the service `testing-pitfall-one`, which creates the extended image `example-extending:testing-pitfall-one` and the detached container `example-extending-testing-pitfall-one` for testing the pitfall:

```yaml
services:
 testing-pitfall-one:
    profiles:
      - all
      - testing-pitfall-one
    build:
      context: ./docker
      dockerfile: Dockerfile
      target: stage_extending_fixing-pitfall-one
    image: example-extending:testing-pitfall-one
    container_name: example-extending-testing-pitfall-one
    hostname: example-extending-testing-pitfall-one
    environment:
      - VNC_RESOLUTION=1024x768
    ports:
      - "45903:5901"  # VNC
      - "46903:6901"  # noVNC
```

You can start the service using the following command:

```shell
docker compose --profile testing-pitfall-one -f extending.yml -p example-extending up -d
```

If you *don't disable* the fixing line in the `Dockerfile`, then the container starts successfully.
You can check the system file permissions by executing the following command *inside* the container:

```shell
$HOME/tests/test-01.sh
```

{% include components/callout-terminal.md %}
> <pre>
> + id
> uid=1000(headless) gid=1000(headless) groups=1000(headless)
> + ls -l /etc/passwd /etc/group
> -rw-r--r-- 1 root root  550 /etc/group
> -rw-r--r-- 1 root root 1193 /etc/passwd
> + tail -n2 /etc/passwd
> systemd-network:x:102:103:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
> systemd-resolve:x:103:104:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin
> + tail -n2 /etc/group
> systemd-resolve:x:104:
> headless:x:1000:
> + ls -ld /dockerstartup /home /home/headless
> drwxr-xr-x 1 headless headless 4096 /dockerstartup
> drwxr-xr-x 1 root     root     4096 /home
> drwxr-xr-x 1 headless headless 4096 /home/headless
> + ls -l /dockerstartup
> total 56
> -rw-r--r-- 1 headless headless 3090 help.rc
> -rw-r--r-- 1 headless headless  495 novnc.log
> -rw-r--r-- 1 headless headless 6721 parser.rc
> -rwxr--r-- 1 headless headless  872 set_user_permissions.sh
> -rwxr-xr-x 1 headless headless 4778 startup.sh
> -rw-r--r-- 1 headless headless 4010 user_generator.rc
> -rwxr--r-- 1 headless headless 5216 version_of.sh
> -rwxr--r-- 1 headless headless 3336 version_sticker.sh
> -rw-r--r-- 1 headless headless  985 vnc.log
> -rw-r--r-- 1 headless headless 4958 vnc_startup.rc
> + mkdir -p /home/headless/new-dir
> + touch /home/headless/new-file
> + ls -l /home/headless
> total 56
> drwxr-xr-x 1 headless headless 4096 Desktop
> drwxr-xr-x 2 headless headless 4096 Documents
> drwxr-xr-x 2 headless headless 4096 Downloads
> drwxr-xr-x 2 headless headless 4096 Music
> drwxr-xr-x 2 headless headless 4096 Pictures
> drwxr-xr-x 2 headless headless 4096 Public
> drwxr-xr-x 2 headless headless 4096 Templates
> drwxr-xr-x 2 headless headless 4096 Videos
> drwxr-xr-x 2 headless headless 4096 new-dir
> -rw-r--r-- 1 headless headless    0 new-file
> -rw-r--r-- 1 headless headless  185 readme.md
> -rw-r--r-- 1 headless headless 1426 test-01.log
> drwxr-xr-x 1 headless headless 4096 tests
> </pre>

The test image and container can be removed using the following command:

```shell
docker compose --profile testing-pitfall-one -f extending.yml -p example-extending down --rmi all
```

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/using-compose/persisting-examples/
[this-goto-next-page]: {{site.baseurl}}/remainder/

[this-using-compose-basic-examples]: {{site.baseurl}}/using-compose/basic-examples/
[this-using-volumes]: {{site.baseurl}}/using-volumes/
[this-headless-working]: {{site.baseurl}}/headless-working/
[this-using-composecommon-assets-user-profile]: {{site.baseurl}}/using-compose/common-assets/#user-profile

[this-firefox-plus]: {{site.baseurl}}/firefox-plus/

[this-container-startup]: {{site.baseurl}}/container-startup/

[github-accetto-user-guide-g3-examples-compose]: https://github.com/accetto/user-guide-g3/tree/main/examples/compose

[dockerhub-accetto-debian-vnc-xfce-vscode-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-vscode-g3

[docker-docs-compose-file-reference]: https://docs.docker.com/compose/compose-file/

[docker-docs-compose-cli]: https://docs.docker.com/compose/reference/

[github-repo-just-the-docs-template]: https://github.com/just-the-docs/just-the-docs-template

[jekyll]: https://jekyllrb.com/
