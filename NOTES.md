Build the docker images:


```
env DEBUG=1 rake build:focal
env DEBUG=1 rake build:bionic
env DEBUG=1 rake build:buster
env DEBUG=1 rake build:stretch
env DEBUG=1 rake build:centos7
env DEBUG=1 rake build:centos8
env DEBUG=1 rake build:fedora31
env DEBUG=1 rake build:fedora29
env DEBUG=1 rake build:linuxbrew
env DEBUG=1 rake build:dotnet
env DEBUG=1 rake build:go
env DEBUG=1 rake build:gradle
env DEBUG=1 rake build:maven
env DEBUG=1 rake build:ruby27
env DEBUG=1 rake build:ruby26
env DEBUG=1 rake build:ruby20
env DEBUG=1 rake build:node10
env DEBUG=1 rake build:node14
```
