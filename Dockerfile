# Rocksdb
#
# Version 0.0.1
# Based on https://github.com/amimimor/docker-rocksdb/blob/master/Dockerfile

# use ubuntu lts base image
FROM ubuntu:14.04

# update
RUN apt-get update -y

# Install git
RUN apt-get install -y git

#
# based on Rocksdb install.md:
#

# Upgrade your gcc to version at least 4.7 to get C++11 support.
RUN apt-get install -y build-essential checkinstall

# Install gflags
RUN apt-get install -y libgflags-dev

# Install snappy
RUN apt-get install -y libsnappy-dev

# Install zlib
RUN apt-get install -y zlib1g-dev

# Install bzip2
RUN apt-get install -y libbz2-dev

# Clone rocksdb and make the static lib
RUN cd /tmp && git clone https://github.com/facebook/rocksdb.git && cd rocksdb && make clean && make shared_lib

# Just grab default ruby (probably pretty old)
RUN apt-get install -y ruby ruby-dev

# Build the rocksdb-ruby gem
RUN gem install rocksdb-ruby -- --with-rocksdb-dir=/tmp/rocksdb/ --with-rocksdb-include=/tmp/rocksdb/include --with-rocksdb-lib=/tmp/rocksdb
