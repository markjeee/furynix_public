FROM gradle:6.5
MAINTAINER hello@gemfury.com

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt -y upgrade

COPY bootstrap/ /bootstrap/
RUN cd /bootstrap && gradle --info test
