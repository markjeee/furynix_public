FROM centos:7
MAINTAINER hello@gemfury.com

RUN yum -y update && yum -y install centos-release-scl && yum-config-manager --enable rhel-server-rhscl-7-rpms

RUN yum install -y which ruby rubygems rh-ruby24
