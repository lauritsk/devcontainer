FROM dhi.io/debian-base:trixie-debian13-dev@sha256:9415967aa0ed8adea8b5c048994259d1982026dca143d0303c7bbe0e11ed67d3

COPY etc/ /etc/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        passwd=1:4.17.4-2 \
        sudo=1.9.16p2-3+deb13u1 \
        fish=4.6.0-1 \
        mise=2026.4.8 \
        tailscale=1.96.4 \
    && pam-auth-update --force --package \
    && groupadd --gid 1000 dev \
    && useradd --uid 1000 --gid 1000 --create-home --shell /usr/bin/fish dev \
    && passwd -d dev \
    && chmod 0440 /etc/sudoers.d/dev \
    && rm -rf /var/lib/apt/lists/*

USER dev
WORKDIR /home/dev

CMD ["fish"]
