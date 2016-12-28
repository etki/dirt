# Pre-release warning

This is a work-in-process project that may never hit a release.

# Semble

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
security hole - you'll have a lot of manual work. Semble aims to solve 
that problem and maintain docker image sources as an easily rebuilt
entity. semble allows you to have a set of source files that are filtered
and optionally rendered for particular versions you may specify, and by
that you may rebuild several version sources from a single source set
using single command.

## Example

Let's continue with example of alpine/debian dockerized service (i'll
name it `neural-subnet` for clarity). Semble expects to see following 
project structure:

```
/semble.yml # semble configuration file (optional, will be discussed later)
/src
  # each directory on this level represents platform
  /_default # default directories serve as base to build on
    /0
      # .semble is a special ignored directory. Here you can set custom 
      # context for specific version via `context.yml` file
      /.semble/context.yml
      /etc/neural-subnet/motd.d/header
      /etc/neural-subnet/neural-subnet.ini
    /1
      /etc/neural-subnet/neural-subnet.yml
      /etc/neural-subnet/.wh.neural-subnet.ini
    /1.1.15
      /etc/neural-subnet/neural-subnet.yml
      /etc/neural-subnet/mask.yml.liquid
    /1.4
      /etc/neural-subnet/.wh.mask.yml.liquid
    /2
      /etc/neural-subnet/extensions.yml
  /debian
    /0
      /Dockerfile 
      /etc/neural-subnet/platform.yml
    /1.2.3
      /Dockerfile
      /usr/local/bin/reload-neural-subnet
    /2
      /Dockerfile
      /usr/local/bin/.wh.reload-neural-subnet
  /alpine
    /0
      /Dockerfile
      /etc/neural-subnet/platform
    /2
      /Dockerfile
```

Whenever Semble receives request to render particular version, it 
computes set of files to be used in that version, acting just like 
layer system inside Docker itself:

```
semble debian:1.4.17
# Start from a layer for default platform, iterating over versions
# platform: -, version: 0.0.0.0, source: src/_default/0
+ /etc/neural-subnet/motd.d/header
+ /etc/neural-subnet/neural-subnet.ini

# platform: -, version: 1.0.0.0, source: src/0/1
+ /etc/neural-subnet/neural-subnet.yml
- /etc/neural-subnet/neural-subnet.ini

# platform: -, version: 1.1.15.0, source: src/0/1.1.15
+ /etc/neural-subnet/mask.yml.liquid
o /etc/neural-subnet/neural-subnet.yml

# platform: -, version: 1.4.0.0, source: src/_default/1.4
- /etc/neural-subnet/mask.yml.liquid

# Not analyzing -:2.0.0.0 - version is higher than specified

# Repeat whole scenario for target platform
# platform: debian, version: 0.0.0.0, source: /src/debian/0
+ /Dockerfile
+ /etc/neural-subnet/platform.yml

# platform: debian, version: 1.2.3.0, source: src/debian/1.2.3
o /Dockerfile
+ /usr/local/bin/reload-neural-subnet

# Not analyzing debian:2.0.0.0 - version is higher than specified

# resulting file set

build/debian-1.4.17/etc/neural-subnet/platform.yml         # source: src/debian/0
build/debian-1.4.17/Dockerfile                             # source: src/debian/1.2.3
build/debian-1.4.17/usr/local/bin/reload-neural-subnet     # source: src/debian/1.2.3
build/debian-1.4.17/etc/neural-subnet/motd.d/header        # source: src/_default/0
build/debian-1.4.17/etc/neural-subnet/neural-subnet.yml    # source: src/_default/1.1.15
```

After resulting file set has been built, semble iterates it again and 
renders all `.liquid` files using provided context, so 
`additional.conf.liquid` would turn into `additional.conf`, if it 
hasn't been wiped. Context for rendered consists of platform 
(`debian`), used version (`1.4.17`) and user-provided values from 
`semble.yml`. `semble.yml`, the last undiscussed aspect, has following 
structure:

```yml
# used to render versions when `semble` is called without arguments
targets:
  # platform: { version: definition, version: definition }
  _default:
    1.4.17: # will result in /build/1.4.17
    1.4.18:
      context:
        enable_debug: true
    1.4.19:
  alpine:
    1.4.17: # will result in /build/alpine-1.4.17
    1.4.18:
  debian:
    1.4.19: # will result in /build/debian-1.4.19
    1.5:
structure:
  # be careful not to set absolute paths if you don't want to
  sources: src
  output: build
# can be either 'latest' (default) or 'none'
# if set to 'latest', semble will generate parent version from it's 
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

The context for rendering templates is built in following way:
- get first (lowest) version context
- override it with later version and iterate until versions end
- add `platform` and `version` entries, where `platform` is simple 
string, and `version` is a hash with keys `full`, `major`, `minor`, `patch`, 
`build` and `classifier`