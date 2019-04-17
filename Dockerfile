FROM ubuntu:latest
RUN apt-get -y update; \
    apt-get -y upgrade; \
    apt-get -y install apt-utils \
    vim \
    htop;
RUN apt-get -y install dstat
CMD ["bash"]