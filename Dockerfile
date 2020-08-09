# docker build --network=host . -t engicam
# docker run --rm -i engicam

FROM ubuntu:16.04

RUN apt-get update && apt-get -y upgrade

# Required Packages for the Host Development System
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 bc \
     xz-utils debianutils iputils-ping

WORKDIR /root/yocto/pyro/sources

RUN git config --global advice.detachedHead false

RUN git clone https://github.com/openembedded/meta-openembedded
RUN git -C meta-openembedded checkout 5e82995
RUN git clone https://github.com/Freescale/fsl-community-bsp-base base
RUN git -C base checkout b7f3aff
RUN git clone https://github.com/meta-qt5/meta-qt5.git
RUN git -C meta-qt5 checkout 31761f6
RUN git clone https://github.com/Freescale/meta-freescale-3rdparty
RUN git -C meta-freescale-3rdparty checkout fd3962a
RUN git clone https://github.com/Freescale/meta-freescale-distro
RUN git -C meta-freescale-distro checkout cd5c7a2
RUN git clone https://github.com/engicam-stable/meta-engicam.git
RUN git -C meta-engicam checkout d3795c5
RUN git clone https://github.com/Freescale/Documentation
RUN git -C Documentation checkout 24f5a21
RUN git clone https://git.yoctoproject.org/git/meta-freescale
RUN git -C meta-freescale checkout 84f328e
RUN git clone https://git.yoctoproject.org/git/poky
RUN git -C poky checkout f0d128e

WORKDIR /root/yocto/pyro

RUN ln -s sources/meta-engicam/tools/engicam-setup-environment .
RUN ln -s sources/base/README .
RUN ln -s sources/base/setup-environment .

RUN MACHINE=microdev . engicam-setup-environment build_microdev

RUN bitbake engicam-demo-qt

CMD "/bin/bash"

