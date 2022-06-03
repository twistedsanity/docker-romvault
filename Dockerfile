FROM jlesage/baseimage-gui:ubuntu-18.04

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        ca-certificates \
        unzip \
        mono-complete \
        libmono-system-servicemodel4.0a-cil \
        libgtk2.0-0 \
        && \
    # Get latest version of ROMVault & RVCmd
#     ROMVAULT_DOWNLOAD=$(curl 'https://www.romvault.com' | \
#         sed -n 's/.*href="\([^"]*\).*/\4/p' | \
#         grep -i download | \
#         grep -i romvault | \
#         sort -r | \
#         head -1) \
#         && \
#     RVCMD_DOWNLOAD=$(curl 'https://www.romvault.com' | \
#         sed -n 's/.*href="\([^"]*\).*/\2/p' | \
#         grep -i download | \
#         grep -i rvcmd | \
#         sort -r | \
#         head -1) \
#         && \
    ROMVAULT_DOWNLOAD=$(curl 'https://www.romvault.com' | \
        sed -n 's/.*href="\([^"]*\).*/\4/p' | \
        grep -i download | \
        grep -i romvault | \
        sort -r | \
        head -1) \
        && \
    RVCMD_DOWNLOAD=$(curl 'https://www.romvault.com' | \
        sed -n 's/.*href="\([^"]*\).*/\2/p' | \
        grep -i download | \
        grep -i rvcmd | \
        sort -r | \
        head -1) \
        && \
    # Document Versions
    echo "romvault" $(basename --suffix=.zip $ROMVAULT_DOWNLOAD | cut -d "_" -f 2) >> /VERSIONS && \
    echo "rvcmd" $(basename --suffix=.zip $RVCMD_DOWNLOAD | cut -d "_" -f 2) >> /VERSIONS && \
    # Download RomVault
    mkdir -p /opt/romvault_downloads/ && \
    curl --output /opt/romvault_downloads/romvault.zip "https://www.romvault.com/download/ROMVault_V3.4.4.zip" && \
    curl --output /opt/romvault_downloads/rvcmd.zip "https://www.romvault.com/download/RVCmd_V3.4.2-Linux-x64.zip" && \
    unzip /opt/romvault_downloads/romvault.zip -d /opt/romvault/ && \
    unzip /opt/romvault_downloads/rvcmd.zip -d /opt/romvault/ && \
    # Clean up
    apt-get remove -y \
        curl \
        wget \
        ca-certificates \
        unzip \
        && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY startapp.sh /startapp.sh
COPY etc/ /etc/

ENV APP_NAME="ROMVault"



# ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

# RUN set -x && \
#     apt-date update
#     apt-get install -y --no-install-recommends \
#         ca-certificates \
#         git \
#         nuget \
#         libgtk-dotnet3.0-cil \
#         software-properties-common \
#         wget \
#         apt-transport-https \
#         && \
#     # install dotnet
#     cd /src
#     wget -nv https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
#     dpkg -i packages-microsoft-prod.deb
#     apt-get update
#     apt-get install -y \
#         dotnet-sdk-3.1 \
#         mono-xbuild \
#         && \

#     # build & install ilrepack
#     git clone --recursive https://github.com/gluck/il-repack.git /src/il-repack
#     cd /src/il-repack

    
#     # install rvworld
#     git clone https://github.com/RomVault/RVWorld.git /src/RVWorld
#     cd /src/RVWorld
#     git fetch origin pull/8/head:pr8
#     git checkout pr8
#     # patch makefile to build on linux
#     sed -i 's/msbuild/dotnet build/g' Makefile
#     # build
#     export FrameworkPathOverride=/usr/lib/mono/4.5/
#     nuget restore
#     make
#     make build-gui
