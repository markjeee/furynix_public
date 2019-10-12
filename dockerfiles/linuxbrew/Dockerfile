FROM linuxbrew/linuxbrew:1.9.3
MAINTAINER hello@gemfury.com

ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt -y update
RUN sudo apt install -y ca-certificates apt-transport-https ruby

RUN git -C "/home/linuxbrew/.linuxbrew/Homebrew" remote set-url origin https://github.com/Homebrew/brew && brew cleanup && brew update
