# Privoxy

_Please note that because of the changes to
[Docker Automated Builds](https://docs.docker.com/docker-hub/builds/) many Docker
images are now outdated and a manual build is required and recommended._

```text
"Privoxy is a non-caching web proxy with filtering capabilities for
enhancing privacy, manipulating cookies and modifying web page data
and HTTP headers before the page is rendered by the browser. Privoxy
is a "privacy enhancing proxy", filtering Web pages and removing
advertisements."
```

Website: <https://www.privoxy.org/>

## Build and run

The image runs as the unprivileged `privoxy` user, uid 100 and gid 101 as
created by the Alpine `privoxy` package, and listens on 8118, so it needs no
added capabilities.

```sh
$ podman build --no-cache -t konstruktoid/privoxy -f Dockerfile .
$ podman run --name privoxy --cap-drop=all --read-only \
    --tmpfs /var/log/privoxy:rw,nosuid,noexec,nodev \
    -d -p 8118:8118 konstruktoid/privoxy
$ curl --proxy 127.0.0.1:8118 --head https://duckduckgo.com
```

The default command is `--no-daemon /etc/privoxy/config`; anything you pass
replaces it.

## Health check

The `HEALTHCHECK` fetches Privoxy's own CGI page through the proxy:

```sh
curl --fail --proxy 127.0.0.1:8118 http://p.p/
```

## Configuration

`files/` is copied to `/etc/privoxy/` and contains `config`, `default.action`,
`default.filter`, `user.action` and `user.filter`.

`config` sets `listen-address 0.0.0.0:8118` and turns off the remote control
surfaces: `enable-edit-actions`, `enable-remote-toggle`,
`enable-remote-http-toggle`, `enable-proxy-authentication-forwarding` and
`allow-cgi-request-crunching` are all `0`. No `logfile` is set, so Privoxy logs
to stderr where the container runtime collects it.

## AppArmor

`./apparmor/` contains an AppArmor profile and its toml source, applied with
`--security-opt="apparmor:docker-privoxy"`.

## Reproducibility

The base image is pinned by digest, so `FROM` always resolves to the same
layers. The Alpine packages installed on top of it are deliberately _not_
version pinned: the image exists to carry the newest patched `privoxy` and
`curl`. Two builds a week apart will therefore contain different package
versions and produce different image digests.

Dependabot moves the base image digest forward; nothing freezes the packages.
If you need a fixed set, build once and refer to the result by digest instead
of by tag.

## Development

`.pre-commit-config.yaml` runs gitleaks, hadolint, actionlint and
markdownlint:

```sh
pre-commit run --all-files
```
