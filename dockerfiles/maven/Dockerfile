FROM maven:3.6.3
MAINTAINER hello@gemfury.com

ENV DEBIAN_FRONTEND=noninteractive

COPY bootstrap/ /bootstrap/
RUN cd /bootstrap && mvn test
