FROM p4lang/p4c:latest
# Install dependencies and some useful tools.
ENV NET_TOOLS iputils-arping \
              iputils-ping \
              iputils-tracepath \
              net-tools \
              nmap \
            #   python-ipaddr \ # now a part of python3
              python3-scapy \
              tcpdump \
              traceroute \
              tshark
ENV MININET_DEPS automake \
                 build-essential \
                 cgroup-tools \
                 ethtool \
                 gcc \
                 help2man \
                 iperf \
                 iproute2 \
                 libtool \
                 make \
                 pkg-config \
                 psmisc \
                 socat \
                 ssh \
                 sudo \
                 telnet \
                 pep8 \
                 pyflakes \
                 pylint \
                 python-pexpect \
                 python-setuptools

# Ignore questions when installing with apt-get:
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends $NET_TOOLS $MININET_DEPS

# Fix to get tcpdump working
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

# Install mininet.
COPY docker/third-party/mininet /third-party/mininet
WORKDIR /third-party/mininet
RUN cp util/m /usr/local/bin/m 
# not sure what this is meant to copy
RUN echo -e "\e[32mInstalling Mininet...\e[0m"
RUN sed -i 's|git://|https://|g' util/install.sh
RUN PYTHON=python3 util/install.sh -fnv
# RUN make install && \
#     rm -rf /third-party/mininet

# Install the scripts we use to run and test P4 apps.

# moved to a mounted volume
# COPY docker/scripts /scripts
# WORKDIR /scripts

# ENTRYPOINT ["./p4apprunner.py"]
