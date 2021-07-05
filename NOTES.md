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


CLI spec coverage:

v  fury accounts
  fury git:config REPO_NAME
  fury git:config:set REPO_NAME KEY=VALUE
  fury git:config:unset REPO_NAME KEY
  fury git:list
  fury git:rebuild REPO_NAME
  fury git:rename REPO_NAME NEW_NAME
  fury git:reset REPO_NAME
  fury help [COMMAND]
v  fury list
  fury login
  fury logout
  fury migrate DIR
v  fury push FILE
v  fury sharing
  fury sharing:add EMAIL
  fury sharing:remove EMAIL
v  fury versions NAME
v  fury whoami
v  fury yank NAME -v, --version=VERSION
 
