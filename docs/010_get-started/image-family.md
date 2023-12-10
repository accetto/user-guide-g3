---
layout: default
title: Image family
parent: Get started
permalink: /image-family/
nav_order: "010.40"
---

# Image family
{: .fs-9 }

quick overview
{: .fs-6 .fw-300 }

{: .fs-5 .fw-300 }
The *accetto images* are based on [Ubuntu][dockerhub-ubuntu] or [Debian][dockerhub-debian] with [Xfce][xfce] desktop.
They all include [VNC server][tigervnc] and [noVNC client][novnc] and are suitable for [headless working][this-headless-working] using common web browsers or VNC viewers.

The [Docker][docker] containers created from the *accetto images* resemble virtual machines.
Despite of technical differences between *Docker containers* and the traditional *virtual machines*, working with *accetto containers* feels quite similar.

The *accetto images* can be pulled from the *accetto image repositories* on Docker Hub.
This [page][this-repositories] contains the concise list of the repositories.

{% include components/collapsible-toc.md %}

The *accetto image family* includes *generic images* and *application images*.
Furthermore, all images are available also in variations with Firefox and Chromium browsers.

All *accetto images* can be used as *base images* and further extended.
Technically there are no dependencies between the generic and application images.

{: .important}
> Please read about [this pitfall][this-pitfall-extending-images-and-failing-startup] before extending the images.

{: .note}
> The *Firefox browser* included with the images based on `Ubuntu 22.04 LTS` is the current *non-snap version* from the *Mozilla Team PPA*.
> It's because of the technical limitations of Docker containers.

{: .note}
> The *Chromium browser* included with the images based on `Ubuntu 20.04 LTS` and `Ubuntu 22.04 LTS` is the current *non-snap version* from the `Ubuntu 18.04 LTS` distribution.
> Besides the browser runs in the `--no-sandbox` mode.
> It's because of the technical limitations of Docker containers.

## Generic images

Generic *accetto images* include all the common features of the *accetto image family*, but no specific additional applications.

They are most often used as *base images* by extending, even if any of *accetto images* can be used for that purpose.

There are also great for learning and testing Linux.

### Ubuntu

There are generic [Ubuntu][dockerhub-ubuntu] images based on the current `Ubuntu 22.04 LTS` and the previous `Ubuntu 20.04 LTS`:

- [accetto/ubuntu-vnc-xfce-g3][ubuntu-vnc-xfce-g3]

![animation-headless-generic-ubuntu][this-animation-headless-generic-ubuntu]

### Ubuntu with Mesa3D and VirtualGL

There are also extended generic images containing [Mesa3D][mesa3d] (OpenGL/WebGL) and [VirtualGL][virtualgl] that are based on the current `Ubuntu 22.04 LTS`:

- [accetto/ubuntu-vnc-xfce-opengl-g3][ubuntu-vnc-xfce-opengl-g3]

{: .tip}
> If you often visit web sites that require WebGL, then use these images.
> It's guaranteed that the included web browsers support WebGL.
> Read more about [WebGL support in web browsers][this-webgl-support].

![animation-headless-generic-opengl][this-animation-headless-generic-opengl]

### Debian

The [Debian][dockerhub-debian] images are based on the current `Debian 12` and the previous `Debian 11`:

- [accetto/debian-vnc-xfce-g3][debian-vnc-xfce-g3]

![animation-headless-generic-debian][this-animation-headless-generic-debian]

### Firefox and Chromium

Probably the most popular variations of the generic images are those with the [Firefox][firefox] and [Chromium][chromium] browsers.

You can use them, for example, as *throw-away browsers* or *domain dedicated browsers*.

There are also very useful as part of *encapsulated development environments*.

The images with Firefox include also [Firefox Plus feature][this-firefox-plus].

The following generic web browser images are based on Ubuntu:

- [accetto/ubuntu-vnc-xfce-chromium-g3][ubuntu-vnc-xfce-chromium-g3]
- [accetto/ubuntu-vnc-xfce-firefox-g3][ubuntu-vnc-xfce-firefox-g3]

![animation-headless-generic-ubuntu-browsers][this-animation-headless-generic-ubuntu-browsers]

The following generic web browser images are based on Debian:

- [accetto/debian-vnc-xfce-chromium-g3][debian-vnc-xfce-chromium-g3]
- [accetto/debian-vnc-xfce-firefox-g3][debian-vnc-xfce-firefox-g3]

![animation-headless-generic-debian-browsers][this-animation-headless-generic-debian-browsers]

{: .tip}
> All *accetto images* are available in the variations with web browsers.
> It allows you to keep your bookmarks *domain oriented*.
> For example, you can keep all bookmarks that are helpful by working with GIMP in the GIMP container itself.

{: .note}
> If you often visit web sites that require WebGL, then read more about [WebGL support in web browsers][this-webgl-support].

## Headless drawing, graphics and modeling

### drawio-desktop

The repository [accetto/ubuntu-vnc-xfce-drawio-g3][ubuntu-vnc-xfce-drawio-g3] contains images that bring [drawio-desktop][drawio-desktop], the desktop version of the popular diagramming and whiteboarding application.

The advantage of the desktop version is, that it's completely isolated from the Internet and you can develop and save all your diagrams locally.

This is an excerpt from the [drawio-desktop][drawio-desktop] author's description:

> Security
>
> draw.io Desktop is designed to be completely isolated from the Internet, apart from the update process.
> This checks github.com at startup for a newer version and downloads it from an AWS S3 bucket owned by Github.
> All JavaScript files are self-contained, the Content Security Policy forbids running remotely loaded JavaScript.
>
> No diagram data is ever sent externally, nor do we send any analytics about app usage externally.
> This means certain functionality for which we do not have a JavaScript implementation do not work in the Desktop build, namely .vsd and Gliffy import.

The images contain the current `drawio-desktop` release installed from the author's public repository.

![animation-headless-drawing-drawio][this-animation-headless-drawing-drawio]

### GIMP

The repository [accetto/ubuntu-vnc-xfce-gimp-g3][ubuntu-vnc-xfce-gimp-g3] contains images that bring the popular image editor [GIMP][gimp] (GNU Image Manipulation Program).

The images contain the current version from the `Ubuntu 22.04 LTS` distribution.

![animation-headless-drawing-gimp][this-animation-headless-drawing-gimp]

### Inkscape

The repository [accetto/ubuntu-vnc-xfce-inkscape-g3][ubuntu-vnc-xfce-inkscape-g3] contains images that bring the popular vector drawing application [Inkscape][inkscape].

The images contain the current version from the `Ubuntu 22.04 LTS` distribution.

![animation-headless-drawing-inkscape][this-animation-headless-drawing-inkscape]

### Blender

The repository [accetto/ubuntu-vnc-xfce-blender-g3][ubuntu-vnc-xfce-blender-g3] contains images that bring the popular 3D creation suite [Blender][blender].

The images contain the current version from the `Ubuntu 22.04 LTS` distribution.

![animation-headless-drawing-blender][this-animation-headless-drawing-blender]

### FreeCAD

The repository [accetto/ubuntu-vnc-xfce-freecad-g3][ubuntu-vnc-xfce-freecad-g3] contains images that bring the popular 3D parametric modeler [FreeCAD][freecad].

The images contain the current `FreeCAD` release installed from the author's public repository.

![animation-headless-drawing-freecad][this-animation-headless-drawing-freecad]

{: .note}
> Please be aware that the FreeCAD images are larger than the other ones and that the download can take some time.
> Also starting the FreeCAD application takes a few seconds, because the large AppImage file must be extracted.
> The following animation illustrates the start-stop cycle.

![animation-freecad-start-stop][this-animation-freecad-start-stop]

## Headless programming

### Postman

The repository [accetto/debian-vnc-xfce-postman-g3][debian-vnc-xfce-postman-g3] contains images that bring the popular [Postman App][postman] with *Scratch Pad* for building and testing REST APIs.

{: .highlight}
> The advantage of *Scratch Pad* is, that you can use *Postman App* without signing-up and to develop and store all your assets locally.
> However, you can also sign-up, if you wish.

{: .important}
> The Postman company has decided to remove *Scratch Pad* from *Postman App* as of May 15, 2023.
> Therefore will these images from now on always include the version 10.13.6, the last one that still contains *Scratch Pad*.

![animation-headless-coding-postman][this-animation-headless-coding-postman]

### Visual Studio Code

The repository [accetto/debian-vnc-xfce-vscode-g3][debian-vnc-xfce-vscode-g3] contains images that bring the popular programming editor [Visual Studio Code][vscode].

The images are intended for creating encapsulated development and testing environments.
They come in several variations and can be further extended and customized.

The included `Visual Studio Code` is the current release installed from the author's public repository.

{: .tip}
> In the section [Using Compose][this-using-compose] in the chapter *Extending examples* you can find the [Jekyll development container][this-using-compose-extending-examples-jekyll] that is almost identical to the one that is used for developing this very *User Guide*.

![animation-headless-coding-vscode][this-animation-headless-coding-vscode]

### Node.js

The repository [accetto/debian-vnc-xfce-nodejs-g3][debian-vnc-xfce-nodejs-g3] contains images that bring the popular JavaScript-based development platform [Node.js][nodejs].

The images are intended for creating encapsulated development and testing environments.
They come in several variations and can be further extended and customized.

The included `Node.js` is the current release installed from the author's public repository.

Publishing of these images will be phased out, because there is more flexible alternative in the repository [accetto/debian-vnc-xfce-nvm-g3][debian-vnc-xfce-nvm-g3].

However, you can always build the images yourself using the GitHub project.

![animation-headless-coding-nodejs][this-animation-headless-coding-nodejs]

### NVM

The repository [accetto/debian-vnc-xfce-nvm-g3][debian-vnc-xfce-nvm-g3] contains images for headless working with the popular JavaScript-based development platform [Node.js][nodejs].

The images are intended for creating encapsulated development and testing environments.
They come in several variations and can be further extended and customized.

However, instead of a particular `Node.js` version they contain the free open-source utility [NVM][nvm] (Node Version Manager), which allows installing and using multiple versions of `Node.js` and `npm` concurrently.

For example, the command `nvm install --lts` will install the latest LTS (Long Term Support) version of `Node.js`.

These images are meant as a more flexible alternative to the ones from the repository [accetto/debian-vnc-xfce-nodejs-g3][debian-vnc-xfce-nodejs-g3], that contain particular `Node.js` versions.

Publishing those images will be phased out, but you can always build them yourself using the GitHub project.

![animation-headless-coding-nvm][this-animation-headless-coding-nvm]

### Python

The repository [accetto/debian-vnc-xfce-python-g3][debian-vnc-xfce-python-g3] contains images that bring the popular programming language [Python][python].

The images are intended for creating encapsulated development and testing environments.
They come in several variations and can be further extended and customized.

The images contain `Python` from the current `Debian 12` distribution.

![animation-headless-coding-python][this-animation-headless-coding-python]

{% include components/bottom-navigation-bar.md %}

<!-- ---- -->

[this-goto-previous-page]: {{site.baseurl}}/quick-start/
[this-goto-next-page]: {{site.baseurl}}/headless-working/

[this-headless-working]: {{site.baseurl}}/headless-working/
[this-repositories]: {{site.baseurl}}/repositories/
[this-using-compose]: {{site.baseurl}}/using-compose/

[this-using-compose-extending-examples-jekyll]: {{site.baseurl}}/using-compose/extending-examples/#jekyll-container-with-vscode-and-firefox

[this-firefox-plus]: {{site.baseurl}}/firefox-plus/

[this-webgl-support]: {{site.baseurl}}/webgl-support/

[this-pitfall-extending-images-and-failing-startup]: {{site.baseurl}}/using-compose/extending-examples/#pitfall-extending-images-and-failing-startup

[this-container-screenshot]: {{site.baseurl}}/assets/images/open-version-sticker.gif

[this-animation-headless-generic-debian]: {{site.baseurl}}/assets/images/animation-headless-generic-debian.gif

[this-animation-headless-generic-opengl]: {{site.baseurl}}/assets/images/animation-headless-generic-opengl-live.gif

[this-animation-headless-generic-ubuntu]: {{site.baseurl}}/assets/images/animation-headless-generic-ubuntu.gif

[this-animation-headless-generic-ubuntu-browsers]: {{site.baseurl}}/assets/images/animation-headless-generic-ubuntu-browsers.gif

[this-animation-headless-generic-debian-browsers]: {{site.baseurl}}/assets/images/animation-headless-generic-debian-browsers.gif

[this-animation-headless-drawing-drawio]: {{site.baseurl}}/assets/images/animation-headless-drawing-drawio-live.gif

[this-animation-headless-drawing-gimp]: {{site.baseurl}}/assets/images/animation-headless-drawing-gimp-live.gif

[this-animation-headless-drawing-inkscape]: {{site.baseurl}}/assets/images/animation-headless-drawing-inkscape-live.gif

[this-animation-headless-drawing-blender]: {{site.baseurl}}/assets/images/animation-headless-drawing-blender-live.gif

[this-animation-headless-drawing-freecad]: {{site.baseurl}}/assets/images/animation-headless-drawing-freecad-live.gif

[this-animation-freecad-start-stop]: {{site.baseurl}}/assets/images/animation-freecad-start-stop.gif

[this-animation-headless-coding-postman]: {{site.baseurl}}/assets/images/animation-headless-coding-postman-live.gif

[this-animation-headless-coding-vscode]: {{site.baseurl}}/assets/images/animation-headless-coding-vscode-live.gif

[this-animation-headless-coding-nodejs]: {{site.baseurl}}/assets/images/animation-headless-coding-nodejs-live.gif

[this-animation-headless-coding-nvm]: {{site.baseurl}}/assets/images/animation-headless-coding-nvm-live.gif

[this-animation-headless-coding-python]: {{site.baseurl}}/assets/images/animation-headless-coding-python-live.gif

[ubuntu-vnc-xfce-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-g3
[ubuntu-vnc-xfce-chromium-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3
[ubuntu-vnc-xfce-firefox-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-firefox-g3

[debian-vnc-xfce-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-g3
[debian-vnc-xfce-chromium-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-chromium-g3
[debian-vnc-xfce-firefox-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-firefox-g3

[ubuntu-vnc-xfce-opengl-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-opengl-g3

[ubuntu-vnc-xfce-blender-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-blender-g3
[ubuntu-vnc-xfce-drawio-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-drawio-g3
[ubuntu-vnc-xfce-freecad-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-freecad-g3
[ubuntu-vnc-xfce-gimp-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-gimp-g3
[ubuntu-vnc-xfce-inkscape-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-inkscape-g3

[debian-vnc-xfce-nodejs-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-nodejs-g3
[debian-vnc-xfce-nvm-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-nvm-g3
[debian-vnc-xfce-postman-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-postman-g3
[debian-vnc-xfce-python-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-python-g3
[debian-vnc-xfce-vscode-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-vscode-g3

[docker]: https://www.docker.com/
[dockerhub-ubuntu]: https://hub.docker.com/_/ubuntu/
[dockerhub-debian]: https://hub.docker.com/_/debian/

[blender]: https://www.blender.org/
[chromium]: https://www.chromium.org/Home
[drawio-desktop]: https://github.com/jgraph/drawio-desktop/
[firefox]: https://www.mozilla.org
[freecad]: https://www.freecadweb.org/
[gimp]: https://www.gimp.org/
[inkscape]: https://inkscape.org/
[mesa3d]: https://mesa3d.org/
[nodejs]: https://www.nodejs.org/
[nvm]: https://github.com/nvm-sh/nvm
[novnc]: https://github.com/kanaka/noVNC
[postman]: https://www.postman.com/downloads/
[python]: https://www.python.org/
[virtualgl]: https://virtualgl.org/About/Introduction
[vscode]: https://code.visualstudio.com/
[tigervnc]: http://tigervnc.org
[xfce]: http://www.xfce.org
