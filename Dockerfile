FROM ubuntu:18.04

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update && \
    apt-get -y install git-core build-essential pkg-config libtool libevent-dev libncurses-dev zlib1g-dev automake libssh-dev cmake ruby locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8

# Use the latest msgpack-c https://github.com/tmate-io/tmate/issues/82#issuecomment-216165761
RUN git clone https://github.com/msgpack/msgpack-c.git && \
    cd msgpack-c && \
    cmake . && \
    make -j 16 && \
    make install && \
    cd ..

# Use latest libssh; see https://github.com/tmate-io/tmate-slave/issues/52
RUN git clone https://git.libssh.org/projects/libssh.git libssh \
    && cd libssh \
    && mkdir -p build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DWITH_EXAMPLES=OFF -DWITH_SFTP=OFF .. \
    && make -j 16 \
    && make install

RUN git clone https://github.com/nviennot/tmate-slave.git
COPY create_keys.sh tmate-slave/
RUN cd tmate-slave \
    && bash create_keys.sh \
    && ./autogen.sh \
    && ./configure \
    && sed -i 's/if (ssh_version(SSH_VERSION_INT(0,8,4)))/return;/' tmate-ssh-latency.c \
    && make -j 16

RUN mkdir /root/tmate-slave
ADD tmate-slave.sh /root/tmate-slave/run

ENTRYPOINT ["/root/tmate-slave/run"]
CMD ["/bin/bash"]


