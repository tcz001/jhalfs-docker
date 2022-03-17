FROM debian:bullseye-slim

# image info
LABEL description="Automated LFS build"
LABEL version="0.1"
LABEL maintainer="fan.torchz@gmail.com"

# LFS mount point
ENV LFS=/mnt/lfs
ENV JHALFS=/mnt/jhalfs

# install required packages
RUN apt-get update && apt-get install -y \
    python3                              \
    build-essential                      \
    bison                                \
    file                                 \
    gawk                                 \
    texinfo                              \
    wget                                 \
    sudo                                 \
    genisoimage                          \
    wget                                 \
    git                                  \
    libxml2-utils                        \
    libxslt-dev                          \
    xsltproc                             \
    gpm                                  \
    lynx                                 \
    subversion                           \
    openssl                              \
    docbook                              \
    docbook-xsl                          \
 && apt-get -q -y autoremove

WORKDIR /bin
RUN rm sh && ln -s bash sh

WORKDIR $LFS
WORKDIR $JHALFS
ADD jhalfs/ $JHALFS/
ADD lfs/ $LFS/

# create lfs user and group
RUN groupadd lfs
RUN useradd -s /bin/bash -g lfs -m -k /dev/null lfs
RUN adduser lfs sudo
RUN chown -R lfs:lfs $LFS 
RUN chown -R lfs:lfs $JHALFS 
# set sudo without password prompt
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER lfs
RUN mkdir -p /mnt/lfs/jhalfs/logs
ENV LFS_SILENT=true
#RUN ./jhalfs.new run
ENTRYPOINT [ "bash" ]
