FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash bison build-essential ca-certificates clang curl file flex g++ gawk \
        gettext git golang-go libelf-dev libncurses-dev libssl-dev perl \
        python3 python3-setuptools rsync subversion swig time \
        unzip wget zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
