# Overview

This is an integration test suite for the Gemfury platform.

The following have been implemented:

* CLI install (rubygems, ubuntu/bionic, ubuntu/xenial, ubuntu/trusty,
  debian/wheezy, debian/jessie, debian/stretch, centos/7, fedora/29,
  fedora/27, fedora/23)
* Ruby integration (ruby 2.6, 2.5, 2.4, 2.3, 1.9)

Future plans:

* Javascript
* Python

# How to setup

The following are needed:


```
ruby 2.5.x
docker 18.x
```

After clone:

```
bundle
rake
```

NOTE: If this is the first time you set up, it will download the
docker images that is used in some of the test environment. Be sure to
have a good Internet connection, since the images are a bit huge.

The following docker images will be pulled:

```
ruby/2.6.0
ruby/2.5.3
ruby/2.4.5
ruby/2.3.8
ruby/1.9.3
ubuntu/bionic
centos/7
```

# Configurations

The following configuration is needed.

Create a .env file with the following configurations:

```
FURYNIX_API_TOKEN=XXXX
```

# Design Notes

Test environment is executed both in the host machine, as well as in a docker
container, based on official images for ruby.

Docker images and containers are auto-created using the docker_task
gem.

# Contribution and Improvements

Please fork the code, make the changes, and submit a pull request for us to review
your contributions.

## Feature requests

If you think it would be nice to have a particular feature that is presently not
implemented, we would love to hear that and consider working on it. Just open an
issue in Github.

# Questions

Please open a Github Issue if you have any other questions or problems.
