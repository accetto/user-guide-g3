### User Guide G3
### Sample Dockerfile

### ##################
### stage_basic-ubuntu
### ##################

FROM accetto/ubuntu-vnc-xfce-g3:latest as stage_basic-ubuntu
COPY ./src/home "${HOME}"/

### ##################
### stage_basic-debian
### ##################

FROM accetto/debian-vnc-xfce-g3:latest as stage_basic-debian
COPY ./src/home "${HOME}"/

### ##################
### stage_basic-opengl
### ##################

FROM accetto/ubuntu-vnc-xfce-opengl-g3:latest as stage_basic-opengl
COPY ./src/home "${HOME}"/

### ########################
### stage_persisting-firefox
### ########################

FROM accetto/debian-vnc-xfce-firefox-g3:latest as stage_persisting-firefox
COPY ./src/home "${HOME}"/
COPY ./src/firefox.plus/user.js "${HOME}/firefox.plus"/

## ######################################
### stage_extending_jekyll-vscode-firefox
### #####################################

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
    # LC_ALL=C.UTF-8 \
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
# RUN gem install jekyll bundler

### ##################################
### stage_extending_fixing-pitfall-one
### ##################################

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

### ##################################
### stage_extending_overriding-example
### ##################################

FROM accetto/ubuntu-vnc-xfce-g3:latest as stage_extending_overriding-example

### overriding and adding environment variables
ENV \
    HEADLESS_USER_ID=2000\
    HEADLESS_USER_GROUP_ID=3000 \
    STAGE=development

USER 0

### changing the container user and the group IDs
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
