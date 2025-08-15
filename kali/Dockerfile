# ===== Stage 1: Dependencies Builder =====
FROM kalilinux/kali-rolling:latest AS deps-builder

ARG TIMEZONE
ARG KBLAYOUT
ARG ROOT_PASSWD
ARG NONROOT_USER
ARG NONROOT_PASSWD

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        sudo openssl wget curl \
        kali-linux-default kali-desktop-xfce \
        xorg xrdp xorgxrdp \
        vim gcc g++ libxml2-dev libxslt-dev python3-dev \
        ffuf crackmapexec burpsuite default-jdk && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get autoremove -y


# ===== Stage 2: Configuration Builder =====
FROM deps-builder AS config-builder

ENV HOME=/root
ENV XRDP_PORT=3390

RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && \
    usermod --password $(echo ${ROOT_PASSWD} | openssl passwd -1 -stdin) root && \
    useradd -ms /bin/bash ${NONROOT_USER} && \
    usermod --password $(echo ${NONROOT_PASSWD} | openssl passwd -1 -stdin) ${NONROOT_USER} && \
    gpasswd -a ${NONROOT_USER} sudo

RUN echo xfce4-session > ${HOME}/.xsession && \
    sed -i "s/test -x/# test -x/g" /etc/xrdp/startwm.sh && \
    sed -i "s/exec/# exec/g" /etc/xrdp/startwm.sh && \
    echo "startxfce4" >> /etc/xrdp/startwm.sh && \
    sed -i "s/3389/${XRDP_PORT}/g" /etc/xrdp/xrdp.ini 

# ===== Stage 3: Final Runtime Image =====
FROM config-builder AS runtime

RUN mkdir -p /root/.BurpSuite /etc/chromium/policies/managed && \
    echo '{"user_options":{"misc":{"embedded_browser":{"allow_running_without_sandbox":true}}}}' > /root/.BurpSuite/UserConfigCommunity.json && \
    echo '{"CommandLineFlagSecurityWarningsEnabled":false,"SandboxExternalProtocolBlocked":false}' > /etc/chromium/policies/managed/burp_policy.json && \
    echo "BURP_BROWSER_SANDBOX=false" >> /etc/environment

RUN printf '#!/bin/bash\nexport CHROME_ARGS="--disable-web-security --disable-features=VizDisplayCompositor --no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage"\nif [ -f /usr/bin/burpsuite ]; then\n    java -jar /usr/bin/burpsuite --disable-sandbox "$@"\nelif [ -f /opt/BurpSuiteCommunity/BurpSuiteCommunity.jar ]; then\n    java -jar /opt/BurpSuiteCommunity/BurpSuiteCommunity.jar --disable-sandbox "$@"\nelse\n    echo "Burp Suite not found. Please install it first."\n    exit 1\nfi' > /usr/local/bin/burpsuite-nosandbox && \
    chmod +x /usr/local/bin/burpsuite-nosandbox

RUN printf '\n# Burp Suite configuration\nexport BURP_BROWSER_SANDBOX=false\nalias burp="burpsuite-nosandbox"\nalias burpsuite="burpsuite-nosandbox"' >> /root/.bashrc

RUN NONROOT_HOME="/home/${NONROOT_USER}" && \
    mkdir -p "${NONROOT_HOME}/.BurpSuite" && \
    cp /root/.BurpSuite/UserConfigCommunity.json "${NONROOT_HOME}/.BurpSuite/" && \
    printf '\n# Burp Suite configuration\nexport BURP_BROWSER_SANDBOX=false\nalias burp="burpsuite-nosandbox"\nalias burpsuite="burpsuite-nosandbox"' >> "${NONROOT_HOME}/.bashrc" && \
    chown -R ${NONROOT_USER}:${NONROOT_USER} "${NONROOT_HOME}/.BurpSuite" "${NONROOT_HOME}/.bashrc" && \
    chown -R ${NONROOT_USER}:${NONROOT_USER} ${HOME}

COPY ./entrypoint.sh /entrypoint.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "xrdp" || exit 1

ENTRYPOINT ["/entrypoint.sh"]

# USER ${NONROOT_USER}
# WORKDIR /home/${NONROOT_USER}


