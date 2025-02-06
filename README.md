# docker-chrony

[![github-actions](https://github.com/theohbrothers/docker-chrony/actions/workflows/ci-master-pr.yml/badge.svg?branch=master)](https://github.com/theohbrothers/docker-chrony/actions/workflows/ci-master-pr.yml)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/docker-chrony?style=flat-square)](https://github.com/theohbrothers/docker-chrony/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/docker-chrony/latest)](https://hub.docker.com/r/theohbrothers/docker-chrony)

Dockerized [chrony](https://chrony.tuxfamily.org/) based on alpine.

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:4.6`, `:latest` | [View](variants/4.6) |
| `:4.5` | [View](variants/4.5) |
| `:4.3` | [View](variants/4.3) |
| `:4.2` | [View](variants/4.2) |
| `:4.1` | [View](variants/4.1) |
| `:4.0` | [View](variants/4.0) |
| `:3.5.1` | [View](variants/3.5.1) |

## Usage

### No NTS

```sh
# Create a custom config file if needed. See: https://chrony.tuxfamily.org/doc/v4.0/chrony.conf.html#examples
cat - > chrony.conf <<'EOF'
pool pool.ntp.org iburst
initstepslew 10 pool.ntp.org
driftfile /var/lib/chrony/chrony.drift
makestep 1.0 3
rtcsync
allow all
EOF

# Start server
docker run -it -p 123:123/udp -v $(pwd)/chrony.conf:/etc/chrony/chrony.conf:ro theohbrothers/docker-chrony:v4.2

# Start server (sync the system clock)
docker run -it --cap-add SYS_TIME -p 123:123/udp -v $(pwd)/chrony.conf:/etc/chrony/chrony.conf:ro theohbrothers/docker-chrony:v4.2 -d
```

### Upstream NTS

```sh
# Create a custom config file if needed. See: https://chrony.tuxfamily.org/doc/v4.0/chrony.conf.html#examples
cat - > chrony.conf <<'EOF'
server time.cloudflare.com iburst nts
initstepslew 10 time.cloudflare.com
driftfile /var/lib/chrony/chrony.drift
makestep 1.0 3
rtcsync
allow all
EOF

# Start server
docker run -it -p 123:123/udp -v $(pwd)/chrony.conf:/etc/chrony/chrony.conf:ro theohbrothers/docker-chrony:v4.2

# Start server (sync the system clock)
docker run -it --cap-add SYS_TIME -p 123:123/udp -v $(pwd)/chrony.conf:/etc/chrony/chrony.conf:ro theohbrothers/docker-chrony:v4.2 -d
```

### From local system clock

```sh
# Create a custom config file if needed. See: https://chrony.tuxfamily.org/doc/v4.0/chrony.conf.html#examples
cat - > chrony.conf <<'EOF'
initstepslew 10 client1 client3 client6
driftfile /var/lib/chrony/chrony.drift
local stratum 8
rtcsync
allow all
EOF

# Start server
docker run -it -p 123:123/udp -v $(pwd)/chrony.conf:/etc/chrony/chrony.conf:ro theohbrothers/docker-chrony:v4.2
```

## Development

Requires Windows `powershell` or [`pwsh`](https://github.com/PowerShell/PowerShell).

```powershell
# Install Generate-DockerImageVariants module: https://github.com/theohbrothers/Generate-DockerImageVariants
Install-Module -Name Generate-DockerImageVariants -Repository PSGallery -Scope CurrentUser -Force -Verbose

# Edit ./generate templates

# Generate the variants
Generate-DockerImageVariants .
```
