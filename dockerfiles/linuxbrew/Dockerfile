FROM linuxbrew/brew:latest
MAINTAINER hello@gemfury.com

ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt -y update
RUN sudo apt install -y ca-certificates apt-transport-https ruby

RUN git -C "/home/linuxbrew/.linuxbrew/Homebrew" remote set-url origin https://github.com/Homebrew/brew && brew cleanup && brew update
