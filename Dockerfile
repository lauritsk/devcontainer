FROM dhi.io/debian-base:trixie-debian13-dev@sha256:9415967aa0ed8adea8b5c048994259d1982026dca143d0303c7bbe0e11ed67d3

COPY etc/ /etc/

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        passwd \
        sudo \
        fish \
        git \
        mise \
        openssh-client \
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
