ARG BASE_IMAGE="ubuntu:18.04"

FROM ${BASE_IMAGE}

WORKDIR /root

# Updating Ubuntu packages
RUN apt-get update && yes|apt-get upgrade
RUN apt-get install -y emacs

# Adding wget and bzip2
RUN apt-get install -y wget bzip2
RUN apt-get install -y gcc

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# Install package
# Must used calibre package to be able to run external module
ENV DEBIAN_FRONTEND noninteractive
RUN \
  apt-get update           && \
  apt-get install -y          \
            curl              \
            lm-sensors        \
            wireless-tools    \
            iputils-ping && \
  rm -rf /var/lib/apt/lists/*

## Install glances
## If version is dev will use git checkout
ADD . /home/glances

# Define working directory.
WORKDIR /home/glances
RUN pip install .

# EXPOSE PORT (XMLRPC / WebUI)
EXPOSE 61209 61208 9091

# Define default command.
CMD python3 -m glances -C ./conf/glances.conf --export prometheus -q
