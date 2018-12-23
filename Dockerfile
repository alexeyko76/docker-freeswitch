FROM debian:stretch-slim
#FROM bitnami/minideb:stretch

MAINTAINER Alexey Koshkin <alexeyko@gmail.com>

RUN apt-get update && apt-get -qq -y install haveged && rm -rf /var/lib/apt/lists/*
#RUN install_packages haveged

ENTRYPOINT ["haveged"]
CMD ["-F", "-w", "1024"]
