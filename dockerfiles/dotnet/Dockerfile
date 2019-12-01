FROM mcr.microsoft.com/dotnet/core/sdk:2.1
MAINTAINER hello@gemfury.com

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update && \
    apt -y upgrade && \
    apt -y install mono-complete && \
    curl -o /usr/local/bin/nuget.exe https://dist.nuget.org/win-x86-commandline/v4.9.4/nuget.exe && \
    echo "alias nuget=\"mono /usr/local/bin/nuget.exe\"" >> ~/.bash_profile
