# CP/M Plus "Continuous Integration" build environment

This repository contains a Docker environment for building CP/M Plus
from source.

## Introduction

[CP/M Plus (aka CP/M 3)](https://en.wikipedia.org/wiki/CP/M#CP/M_Plus)
was an 8-bit operating system released in 1983 by Digital Research Inc,
for 8080 / Z80 based microcomputers.  CP/M Plus, and the earlier CP/M 2.2,
were widely ported to many microcomputers during the 1980s.

Much later, in the late 1990s or early 2000s various [source code to
Digital Research microcomputer products was
released](http://www.cpm.z80.de/source.html), under various licenses
from the then corporate owners of Digital Research assets.  This
included source code for (most of) CP/M Plus.

The [current license for the CP/M Plus source
code](http://www.cpm.z80.de/license.html) is from an email to the
maintainers of [The Unofficial CP/M Web Site](http://www.cpm.z80.de/),
and says in the key part:

> Let this paragraph represent a right to use, distribute, modify,
> enhance, and otherwise make available in a nonexclusive manner CP/M
> and its derivatives. This right comes from the company, DRDOS, Inc.'s
> purchase of Digital Research, the company and all assets, dating back
> to the mid-1990's. DRDOS, Inc. and I, Bryan Sparks, President of DRDOS,
> Inc. as its representative, is the owner of CP/M and the successor in
> interest of Digital Research assets.

(where DRDOS was originally the Digital Research version of DOS, derived
from CP/M-86 plus some comptability layers).

## Building CP/M Plus

[John Elliot](http://www.seasip.info/index.html) did all the work to
determine how to build CP/M Plus under Linux, including writing a couple
of emulators to run the build tools under Linux:

*   [ZXCC](http://www.seasip.info/Unix/Zxcc/) which runs CP/M binaries
    under Linux, with I/O redirection to files

*   [Thames](http://www.seasip.info/Unix/Thames/) which runs Intel ISIS-II
    binaries under Linux, with I/O redirection to files

The build process is bootstrapped from the 
[Intel ISIS II](https://en.wikipedia.org/wiki/ISIS_(operating_system))
environment ("Intel System Implementation Supervisor"), where the 
[PL/M (Programming Language for Microcomputers)](https://en.wikipedia.org/wiki/PL/M)
compiler (`plm80`) and Intel assembler (`asm80`) were run to build the
source, with later steps being done in a CP/M environment.

This repository just automates installing ZXCC, Thames, the PLM80/ASM80
compiler/assembler, and setting up the build environment.  Then runs the
Makefile provided by John Elliot, and copies the generated output files.

## Usage

Install Docker, and make sure it is usable by the user you are running
these tools.

Optionally run:

    ./download-tools

first to download from the Internet the source and tools required (this
is a one time download step).

Optionally run:

    docker build -t cpm-ci .

to pre-build the Docker image with the emulator/compiler tools ready to use.

Then run:

    ./build-cpm

in the top level directory to build CP/M from the
`cpm-source/cpm3src_unix.zip` file, and place the generated files in the
`output/` directory.  (It will automatically run the `./download-tools`
step, and the `docker build -t cpm-ci .` step, if it detects those have
not been done.)
