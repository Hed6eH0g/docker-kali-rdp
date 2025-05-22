FROM kalilinux/kali-rolling:latest

ARG TIMEZONE
ARG KBLAYOUT
ARG ROOT_PASSWD
ARG NONROOT_USER
ARG NONROOT_PASSWD

ENV TZ=${TIMEZONE}
ENV ROOT_PASSWD=${ROOT_PASSWD}
ENV NONROOT_USER=${NONROOT_USER}
ENV NONROOT_PASSWD=${NONROOT_PASSWD}

# ENV HOME=/home/${NONROOT_USER}
ENV HOME=/root
ENV INSTALL=/tmp/install

# install essentials
RUN apt-get update && \
	apt-get install --fix-missing && \
	apt-get install -y \
		sudo \
		openssl && \
    rm -rf /var/lib/apt/lists/*
	

# setup for timezone, keyboard layout, and openvpn
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
# RUN setxkbmap -layout ${KBLAYOUT}
RUN mkdir -p /dev/net && mknod /dev/net/tun c 10 200

# set root's password
RUN usermod --password $(echo ${ROOT_PASSWD} | openssl passwd -1 -stdin) root

# create normal user
RUN useradd -ms /bin/bash ${NONROOT_USER} && usermod --password $(echo ${NONROOT_PASSWD} | openssl passwd -1 -stdin) ${NONROOT_USER}
RUN gpasswd -a ${NONROOT_USER} sudo 

RUN mkdir -p ${INSTALL}

COPY ./install/* ${INSTALL}/
COPY ./entrypoint.sh ${HOME}/entrypoint.sh

RUN bash ${INSTALL}/xrdp.sh
RUN bash ${INSTALL}/tools.sh

# switch to non-root user
RUN chown -R ${NONROOT_USER}:${NONROOT_USER} ${HOME}

# USER ${NONROOT_USER}
WORKDIR ${HOME}

CMD bash -c "bash ${HOME}/entrypoint.sh"

