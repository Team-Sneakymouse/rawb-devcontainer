FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG USERNAME=pelican
ARG USER_UID=988
ARG USER_GID=988

RUN groupadd --gid "${USER_GID}" "${USERNAME}" \
    && useradd --uid "${USER_UID}" --gid "${USER_GID}" --create-home --shell /bin/bash "${USERNAME}" \
    && apt-get update \
    && apt-get install --yes --no-install-recommends openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && install -d -m 0700 -o "${USERNAME}" -g "${USERNAME}" "/home/${USERNAME}/.ssh" \
    && install -d -m 0700 /etc/ssh/host-keys

COPY --chown=${USERNAME}:${USERNAME} ssh-keys/ /tmp/rawb-ssh-keys/
RUN find /tmp/rawb-ssh-keys -type f -name '*.pub' -exec cat {} + > "/home/${USERNAME}/.ssh/authorized_keys" \
    && chown "${USERNAME}:${USERNAME}" "/home/${USERNAME}/.ssh/authorized_keys" \
    && chmod 0600 "/home/${USERNAME}/.ssh/authorized_keys" \
    && rm -rf /tmp/rawb-ssh-keys \
    && printf '%s\n' \
        'PasswordAuthentication no' \
        'KbdInteractiveAuthentication no' \
        'PermitRootLogin no' \
        'PubkeyAuthentication yes' \
        'AllowUsers pelican' \
        > /etc/ssh/sshd_config.d/rawb.conf

COPY docker-entrypoint.sh /usr/local/bin/rawb-entrypoint
RUN chmod 0755 /usr/local/bin/rawb-entrypoint

WORKDIR /home/${USERNAME}

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/rawb-entrypoint"]
CMD ["/usr/sbin/sshd", "-D", "-e", "-h", "/etc/ssh/host-keys/ssh_host_ed25519_key"]
