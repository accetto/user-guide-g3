---
layout: default
title: Common assets
parent: Using Compose
permalink: /using-compose/common-assets/
nav_order: "060.10"
---

# Common assets
{: .fs-9 }

used in Compose examples
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
There are some common assets used by all examples.
Their purpose is to demonstrate the concept, not to bring any significant value.
You can modify them as you need or leave them out completely.

[Examples: Compose][github-accetto-user-guide-g3-examples-compose]{: .btn .fs-2 }

{% include components/collapsible-toc.md %}

## Folder tree

The following folder tree is used by all examples:

```text
user-guide-g3/
|__ examples/
    |__ compose/
        |__ basic.yml
        |__ persisting.yml
        |__ extending.yml
        |__ docker/
            |__ Dockerfile
            |__ src/
                |__ home/
                |   |__ .bashrc
                |   |__ config/
                |       |__ xfce4/xfconf/xfce-perchannel-xml/
                |           |__ keyboard-layout.xml
                |__ firefox.plus/
                    |__ user.js
```

## User profile

Customization of the user profile is demonstrated by the sample file `.bashrc`.

The file contains a few simple, but useful aliases:

```shell
### some examples of custom aliases

alias ll="ls -l"

### clear console window
alias cls='printf "\033c"'

### change the console prompt using 'ps1'
fn_ps1() {
    if [ $# -gt 0 ] ; then
        ### given value in bold green
        PS1="\[\033[01;32m\]$1\[\033[00m\]> "
    else
        ### basename of the current working directory in bold blue
        PS1='\[\033[01;34m\]\W\[\033[00m\]> '
    fi
}
alias ps1='fn_ps1'
```

{: .explain}
> Alias `ll` is just the common `ls -l` command.
>
> Alias `cls` clears the terminal window.
>
> Alias `ps1` sets a new terminal prompt text.
> If it gets a single *prompt text* parameter, then it displays it in bold green.
> Otherwise the *basename* of the current directory is displayed in bold blue.
>
> The animation in the section [Basic examples][this-using-compose-basic-examples] shows the `ps1` alias in action.

## Xfce configuration

Customization of the desktop environment is demonstrated by changing the set of active keyboard layouts.

It's done by overriding the configuration file `keyboard-layout.xml`.

The default set contains the following keyboard layouts:

- English (US)
- French
- German
- Italian

The customized set contains the following keyboard layouts:

- English (US)
- German
- Italian
- Spanish

This is the content of the customized configuration file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="keyboard-layout" version="1.0">
  <property name="Default" type="empty">
    <property name="XkbDisable" type="bool" value="false"/>
    <property name="XkbLayout" type="string" value="us,de,it,es"/>
    <property name="XkbVariant" type="string" value=",,,"/>
  </property>
</channel>
```

You can adjust the set of active keyboard layouts by modifying the value of the property `XkbLayout`.

Here are some samples of the keyboard layout abbreviations you can choose from:

| Value | Keyboard layout          |
| :---: | :----------------------- |
|  us   | English (US)             |
|  gb   | English (UK)             |
|  be   | Belgian                  |
|  dk   | Danish                   |
|  nl   | Dutch                    |
|  fr   | French                   |
|  ca   | French (Canada)          |
|  de   | German                   |
|  it   | Italian                  |
|  pt   | Portuguese               |
|  br   | Portuguese (Brasil)      |
|  es   | Spanish                  |
| latam | Spanish (Latin American) |

{: .note}
> You can configure up to 4 active keyboard layouts.

## Firefox preferences

Customization of the Firefox preferences is represented by the sample file `user.js`, which will be copied into the folder `$HOME/firefox.plus` inside the container.

The provided sample file `user.js` is, in effect, empty, because it contains only comments:

```javascript
// Add the preferences you want to force here.
// They will be forced for each session, but only in profiles containing this file.

// Disable WebRTC leaks as explained in https://ipleak.net/#webrtcleak
// Be aware that this has impact on some applications, e.g. some messengers.
// user_pref("media.peerconnection.enabled", false);

// force value of 'Always ask you where to save files'
// user_pref("browser.download.useDownloadDir", false);
```

The section [Firefox Plus feature][this-firefox-plus] describes how you can modify the file.

## Dockerfile

The sample file `Dockerfile` is a multi-staged Dockerfile and it's common for all examples.

It is stored in the folder `user-guide-g3/examples/compose/docker`, which is the root of the Docker building context.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/using-compose/
[this-goto-next-page]: {{site.baseurl}}/using-compose/basic-examples/

[this-using-compose-basic-examples]: {{site.baseurl}}/using-compose/basic-examples/

[this-firefox-plus]: {{site.baseurl}}/firefox-plus/

[github-accetto-user-guide-g3-examples-compose]: https://github.com/accetto/user-guide-g3/tree/main/examples/compose
