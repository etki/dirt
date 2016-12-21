# Pre-release warning

This is a work-in-process project that may never hit a release.

# Docker Image Release Tool

This is a simple project to speed up multi-version Docker image 
building.

Imagine you have to maintain an image for a service that has 
several versions and several platforms (e.g. debian for backward 
compatibility and alpine), and your dockerfile looks just like that:

```dockerfile
RUN curl https://releases.company.com/product/$VERSION.deb > /tmp/package.deb

RUN dpkg -i /tmp/package.deb # apk magic for alpine
```

While they differ only a little, you need some sophisticated management
to update all maintained versions at once. If you store each version in
a separated branch and need to add new `RUN` instruction, say, to fix a
security hole - you' ll have a lot of manual work. Dirt aims to solve 
that problem and maintain docker image sources as an easily rebuilt
entity. Dirt allows you to have a set of source files that are filtered
and optionally rendered for particular versions you may specify, and by
that you may rebuild several version sources from a single source set
using single command.

## Example

Let's continue with example of alpine/debian dockerized service. Dirt
expects to see following project structure:

```
/dirt.yml # Dirt configuration file (optional)
/src
  # each directory on this level represents platform
  /default # default directories serve as base to build on
    /default
      /service.conf
    /1.1.15
      /additional.conf.liquid
  /debian
    /default
      /Dockerfile
    /1.2.3
      /Dockerfile
    /1.4.3
      /Dockerfile
      /.wh.additional.conf.liquid
  /alpine
    /default
      /Dockerfile
```

Whenever dirt receives a request ot build particular version, it 
computes set of files to be used in that version, acting just like 
layer system inside Docker itself:

```
dirt build debian:1.4.17
# start from a layer for default platform, default version
#/src/default/default
/service.conf
# add a layer from target platform (debian), default version
#/src/debian/default
/Dockerfile
# add layer for every version <= target version for default platform
#/src/default/1.1.15
/additional.conf.liquid 
# add layer for every version <= target version for target platform
#/src/debian/1.2.3
/Dockerfile
#/src/debian/1.4.3
/.wh.additional.conf.liquid # wipe away additional.conf.liquid

# resulting file set
/build/debian-1.4.17/service.conf  # sourced from /src/default/default
/build/debian-1.4.17/Dockerfile    # sourced from /src/debian/1.2.3/Dockerfile
```

After resulting file set has been built, dirt iterates it again and 
renders all `.liquid` files using provided context, so 
`additional.conf.liquid` would turn into `additional.conf`, if it 
hasn't been wiped. Context for rendered consists of platform 
(`debian`), used version (`1.4.17`) and user-provided values from 
`dirt.yml`. `dirt.yml`, the last undiscussed aspect, has following 
structure:

```yml
# used to render versions when `dirt build` is called without arguments
versions:
  # platform: [ version, version ]
  default:
    - 1.4.17 # will result in /build/1.4.17
    - 1.4.18
    - 1.4.19
  alpine:
    - 1.4.17 # will result in /build/alpine-1.4.17
    - 1.4.18
  debian:
    - 1.4.19 # will result in /build/debian-1.4.17
    - 1.5 # will be expanded to 1.5.0
configuration:
  structure:
    sources: /src
    output: /build
  # can be either 'latest' (default) or 'none'
  # if set to 'latest', dirt will generate parent version from it's 
  # latest child (if parent version doesn't exist), so /build/1.4 will 
  # be a complete copy of /build/1.4.19, and /build/1 would be a copy 
  # of build/1.4, similar actions would be taken against 'alpine' and 
  # 'debian' platform
  # if 'none' set, nothing will happen
  short_version_strategy: latest
  # if this is set, target platorm versions that do not exist in 
  # default platform will be copied from target platform, so, in
  # this example, /build/1.5.0 will be a copy from /build/debian-1.5.0
  default_platform: debian
```