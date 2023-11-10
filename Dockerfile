# Docker file to create a build environment for CP/M
#
# The cross-compiler image can be built with:
#
# export NO_COLOR=1
# docker build -t cpm-ci .
#
# to download/compile the build tools (NO_COLOR to turn off use of blue
# on black for progress messages, which is utterly unreadable)
#
# To build cpm-source/cpm3src_unix.zip with any patches in cpm-source/patches
# run:
#
# ./build-cpm
#
# along side Dockerfile, and the resulting files will be in output/
#
# Written by Ewen McNeill <ewen@naos.co.nz
#
#---------------------------------------------------------------------------
# SPDX-License-Identifier: MIT
#
# MIT copyright license for these "Continuous Integration" wrappers around the
# CP/M Plus build tools (CP/M Plus and the other tools use have their
# own copyrights; CP/M Plus has a non-commercial license).
# 
# Copyright 2023 Ewen McNeill
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the “Software”), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
# THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#---------------------------------------------------------------------------

# Use Debian 12 (Bookworm): https://hub.docker.com/_/debian
FROM debian:12

# Copy in the build tools
ADD emulators                     /emulators
ADD plm-isis-compiler/plm80.zip   /emulators/plm80.zip

# Install Linux build tools, and archive tools
RUN apt-get update                && \
    apt-get -y install build-essential file libncurses-dev unzip zip

# Build thames ISIS emulator (default install is to /usr/local, which is fine)
RUN cd /emulators                 && \
    tar -xzvf thames-0.1.1.tar.gz && \
    cd thames-0.1.1               && \
    ./configure                   && \
    make && make install

# Build zxcc CP/M emulator (default install is to /usr/local, which is fine)
# cpmio, included in zxcc, needs ncurses development library
RUN cd /emulators                 && \
    tar -xzvf zxcc-0.5.7.tar.gz   && \
    cd zxcc-0.5.7                 && \
    ./configure                   && \
    make && make install

# Extract the PLM80 / ASM80 compiler/assembler (Intel ISIS tools)
# 
# This distribution contains some self-extracting zip files (DOS .EXE)
# which we need to extract.  Both the PLM80.EXE and ASM80.EXE self extracting
# zip files contain the "UTILS" folder, with identical contents, so we just
# ignore it from the second file (with -n).
#
# We force the extracted files in the self extracting zip to be lower case,
# to match the Makefile in the CPM3 (Unix Build Directory) source.
#
RUN mkdir /emulators/plm80        && \
    cd /emulators/plm80           && \
    unzip ../plm80.zip            && \
    unzip -L PLM80.EXE            && \
    unzip -L -n ASM80.EXE

CMD /bin/sh /src/build-cpm
