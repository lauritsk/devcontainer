FROM dhi.io/debian-base:trixie-debian13-dev

COPY etc/ /etc/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        passwd \
        sudo \
        fish \
        mise \
        tailscale \
    && pam-auth-update --force --package \
    && groupadd --gid 1000 dev \
    && useradd --uid 1000 --gid 1000 --create-home --shell /usr/bin/fish dev \
    && passwd -d dev \
    && chmod 0440 /etc/sudoers.d/dev \
    && rm -rf /var/lib/apt/lists/*

USER dev
WORKDIR /home/dev

CMD ["fish"]
