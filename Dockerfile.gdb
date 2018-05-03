FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
    gdb \
    vim \
    git \
    python \
    python-pip \
    python-dev \
    python-ipdb \
    ipython \
    python3 \
    python3-pip \
    python3-dev \
    python3-ipdb \
    ipython3 \
    sudo \
    wget \
    autoconf

# GDB deps
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    libreadline-dev \
    texinfo

WORKDIR /root

RUN wget https://ftp.gnu.org/gnu/gdb/gdb-8.1.tar.xz

# Verify sig
ADD ./gdb-8.1.tar.xz.sig /root/
RUN gpg --keyserver keys.gnupg.net --recv-keys 92EDB04BFF325CF3
RUN gpg --verify ./gdb-8.1.tar.xz.sig ./gdb-8.1.tar.xz

RUN xz -d gdb-8.1.tar.xz && tar -xvf gdb-8.1.tar && mv gdb-8.1 gdb_src

# Prepare directories for GDB with py2 and py3
RUN mkdir /root/gdb-py2 /root/gdb-py3

# Build GDB with python2
RUN cd /root/gdb_src && mkdir build-py2 && cd build-py2 && \
    ../configure --prefix=/root/gdb-py2 --disable-nls --disable-werror --with-system-readline --with-python=/usr/bin/python2 --with-system-gdbinit=/etc/gdb/gdbinit --enable-targets=all && \
    make -j4 && make install && cd ..

# Build GDB with python3
RUN cd /root/gdb_src && mkdir build-py3 && cd build-py3 && \
    ../configure --prefix=/root/gdb-py3 --disable-nls --disable-werror --with-system-readline --with-python=/usr/bin/python3.5 --with-system-gdbinit=/etc/gdb/gdbinit --enable-targets=all && \
    make -j4 && make install && cd ..

