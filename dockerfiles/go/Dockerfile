FROM golang:1.13.5
MAINTAINER hello@gemfury.com

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt -y upgrade

RUN echo '\n\
    export PATH=/usr/local/go/bin:$PATH\n'\
    >> /root/.profile

RUN git config --global user.email "hello@gemfury.com" && \
    git config --global user.name "Furynix"
