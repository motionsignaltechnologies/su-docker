#Copyright 2019 Motion Signal Technologies 
#
#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
#2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

###################################################################
# Ubuntu base image
###################################################################
FROM ubuntu:18.04

###################################################################
# Install some basic pre-requisites and build SU
###################################################################

RUN apt-get update && apt-get install -y \
    build-essential \
    libx11-dev \
    libxt6 libxt-dev \
    git \
    && git clone "https://github.com/JohnWStockwellJr/SeisUnix.git" su/ \
    && mv su /root/cwp \
    && /bin/bash -c \
       'echo exit 0 > /root/cwp/src/license.sh \
       && echo exit 0 > /root/cwp/src/mailhome.sh \
       && echo exit 0 > /root/cwp/src/chkroot.sh \
       && CWPROOT=/root/cwp PATH=$PATH:/root/cwp/bin make -C /root/cwp/src install xtinstall' \
    && rm -rf /root/cwp/src /root/cwp/.git* /root/cwp/.git* README.git.instructions \
    && apt-get remove -y \
       build-essential \
       libx11-dev \
       libxt-dev \
       curl \
    && rm -rf /var/lib/apt/lists \
    && apt-get autoremove -y \
    && apt-get autoclean -y

ENV PATH "${PATH}:/root/cwp/bin"
ENV LD_LIBRARY_PATH  "${LD_LIBRARY_PATH}:/root/cwp/lib"


