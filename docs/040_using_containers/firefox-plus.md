---
layout: default
title: Firefox Plus
parent: Using containers
permalink: /firefox-plus/
nav_order: "040.100"
---

# Firefox Plus
{: .fs-9 }

feature explained
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
The *Firefox Plus* feature is included with the images that contain Firefox browser.
It is a unique feature of *accetto images*.

{% include components/collapsible-toc.md %}

[MozillaZine user.js][firefox-user-js]{: .btn .fs-2 }

## Concept of Firefox Plus

Firefox browser supports pre-configuration of user preferences.

Users can enforce their personal browser preferences if they put them into a file called `user.js` and then copy the file into the Firefox profile folder.

The `Firefox Plus` is a set of utilities that simplify these tasks.

For a good description of `user.js` you can visit this [MozillaZine page][firefox-user-js].

## Firefox Plus content

The *Firefox Plus* set includes the following:

- On desktop
  - launcher `FF Profile Manager`
  - launcher `Copy FF Preferences`

- In folder `$HOME/firefox.plus`
  - `user.js` file template
  - script `copy_firefox_user_preferences.sh`

![Firefox Plus content][this-image-firefox-plus-content]

## Firefox Plus exercise

General usage pattern is really simple:

1. Create Firefox profile(s)
2. Prepare `user.js` file containing personal preferences
3. Copy `user.js` file into Firefox profile(s)

If you're not familiar with the Firefox profiles and preferences, you can find the following simple exercise useful.

### Exercise container

The following detached container called `devrun` is used throughout the exercise:

```shell
docker run -d -p "35901:5901" -p "36901:6901" --name devrun --hostname devrun accetto/ubuntu-vnc-xfce-firefox-g3
```

Afterwards you can remove the container using the following commands:

```shell
docker rm -f devrun
```

The section [Headless working][this-headless-working] describes how to connect to the container.

### Create Firefox profile automatically

The Firefox profiles can be created automatically or manually.

A profile itself is a folder tree that is created under the folder `$HOME/.mozilla/firefox/`.

The automatic Firefox profile is created during the first Firefox start.

The actual profile folder gets a random name according the pattern `*.default-release`.

![Automatic Firefox profile][this-image-firefox-plus-automatic-profile]

### Create Firefox profile manually (optional)

If you want more control over the profile creation or you want to add additional profiles, then you can use the `Firefox Profile Manager`.

You can start it using the convenience launcher `FF Profile Manager` on the desktop.

Optionally you can also create the profiles in the *offline mode*.

The following animation shows how to create the first profile called `Default User` in offline mode.
Afterwards you can continue with the first Firefox start, optionally also in the offline mode.

![Manual Firefox profile][this-animation-firefox-plus-manual-profile]

### Prepare Firefox preferences

Your personal Firefox preferences should be put into the file `$HOME/firefox.plus/user.js`.

It's a simple JavaScript file and its syntax is explained on this [MozillaZine page][firefox-user-js].

{: .tip}
> The simplest way to prepare the `user.js` content is to configure your Firefox the usual way and then use the content of the `prefs.js` file from the profile folder as the starting point.
> Remove all unnecessary entries and add the preferences you want to enforce.
> Note that the file does not contain entries of the preferences that have never been changed from their default values.

{: .use_case}
> Let's say, that you want that Firefox always asks where to save the downloaded files:
>
> ![Firefox preferences example 01][this-firefox-preferences-example-01]

First you would add the following line into the file `$HOME/firefox.plus/user.js`:

```js
user_pref("browser.download.useDownloadDir", false);
```

Then you would delete the current profile including the files and create a new one.

![Delete Firefox profile][this-animation-firefox-plus-delete-profile]

Before continuing you can verify that the checkbox `Always ask you where to save files` is not enabled by default.

### Apply Firefox preferences

You can enforce your personal Firefox preferences by copying the file `$HOME/firefox.plus/user.js` into the Firefox profile folder.

You can do it manually or you can use the provided utility script `copy_firefox_user_preferences.sh`.

You can start the script using the convenience launcher `Copy FF Preferences` on the desktop.

The script will list all available Firefox profiles and you can copy the `user.js` file into a selected individual profile or into all of them at once.

The profile list items has the following structure:

| Line | Status | Profile               |
|:----:|:------:|:----------------------|
|   1  |  -/+   | profile folder name   |

{: .explain}
> `Line` is the profile number you should use by choosing the particular profile.
>
> `Status` is the information if the `user.js` file is already in the profile folder.
> The `-` means that the file is not there yet, the `+` means the opposite.
>
> `Profile` is the actual name of the Firefox profile folder.

The following animation shows how to copy the `user.js` file into the profile number `1` and to check it afterwards.

![Copy user.js][this-animation-firefox-plus-copy-userjs]

### Exercise results

In one of the previous steps you have created a fresh new Firefox profile and you have verified that the checkbox `Always ask you where to save files` has not been checked by default.

After copying the prepared `user.js` file into the profile you should see that the checkbox is already checked.

{: .important}
> You should notice that the checkbox `Always ask you where to save files` will be *always* checked in all the profiles that contain your `user.js` file.
> Even if you clear the checkbox in the Firefox `Settings`, it will be checked the next time you open Firefox.
>
> The `user.js` file in the Firefox profile folder *enforces* all the settings it contains until you remove them from the file or you remove the file itself from the Firefox profile folder.

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/webgl-support/
[this-goto-next-page]: {{site.baseurl}}/version-sticker/

[this-headless-working]: {{site.baseurl}}/headless-working/

[this-image-firefox-plus-content]: {{site.baseurl}}/assets/images/firefox-plus-content.png

[this-image-firefox-plus-automatic-profile]: {{site.baseurl}}/assets/images/firefox-plus-automatic-profile.png

[this-firefox-preferences-example-01]: {{site.baseurl}}/assets/images/firefox-preferences-example-01.png

[this-animation-firefox-plus-manual-profile]: {{site.baseurl}}/assets/images/animation-firefox-plus-manual-profile.gif

[this-animation-firefox-plus-delete-profile]: {{site.baseurl}}/assets/images/animation-firefox-plus-delete-profile.gif

[this-animation-firefox-plus-copy-userjs]: {{site.baseurl}}/assets/images/animation-firefox-plus-copy-userjs.gif

[accetto-github]: https://github.com/accetto

[firefox-user-js]: http://kb.mozillazine.org/User.js_file
