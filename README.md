# RAWB devcontainer

Development container for editing the MagicSpells YAML configuration of the
`old-dev` Minecraft server.

The container bind-mounts this host directory:

```text
/docker/pelican/mounts/old-dev/plugins/MagicSpells
```

at `/workspace/old-dev`. The container user is `pelican` with UID and GID 988,
matching Pelican's ownership of the server files.

## Open the devcontainer

Clone this repository on the Minecraft server and open it in a devcontainer.
Docker Compose builds the image locally as `rawb-devcontainer:local` by default.

To update the container on the host, run the update script from the repository:

```bash
bash ./update.sh
```

The script performs a fast-forward-only `git pull`, then runs
`docker compose up -d --build` so Dockerfile changes and SSH key changes are
included in the replacement container. It stops immediately if either step
fails.

The bind-mount source is intentionally host-specific and must exist before the
container starts.

## SSH access

Put each permitted public key in `ssh-keys/` with a `.pub` extension, for
example `ssh-keys/dani-laptop.pub`, and rebuild the image. All matching files
are combined into the `pelican` user's `authorized_keys` file at build time.

SSH listens on host port 2255 by default:

```bash
ssh -p 2255 pelican@minecraft-server.example.com
```

Set `RAWB_SSH_PORT` to use a different host port. Password authentication,
keyboard-interactive authentication, and root login are disabled. The server's
SSH host key is stored in a named Docker volume so it remains stable across
image updates and container recreation.
