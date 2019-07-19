FROM debian:jessie
RUN \
  apt-get update && \
  apt-get install -y \
    git \
    vim
COPY riverrun.txt /src/rivverrun.txt