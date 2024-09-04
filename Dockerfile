#
# Github-Actions runner image.
#

FROM rodnymolina588/ubuntu-jammy-docker
LABEL maintainer="rodny.molina@docker.com"

ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
RUN mkdir -p /opt/hostedtoolcache

ARG GH_RUNNER_VERSION="2.309.0"

ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends dumb-init jq \
  && groupadd -g 121 runner \
  && useradd -mr -d /home/runner -u 1001 -g 121 runner \
  && usermod -aG sudo runner \
  && usermod -aG docker runner \
  && echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

WORKDIR /actions-runner
COPY scr/install_actions.sh /actions-runner

#!/bin/bash -ex
GH_RUNNER_VERSION=$1
TARGETPLATFORM=$2

RUN curl -L "https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-${TARGET_ARCH}-${GH_RUNNER_VERSION}.tar.gz" > actions.tar.gz
RUN tar -zxf actions.tar.gz
RUN rm -f actions.tar.gz
RUN ./bin/installdependencies.sh
RUN mkdir /_work

## RUN chown runner /_work /actions-runner /opt/hostedtoolcache

COPY scr/token.sh scr/entrypoint.sh scr/app_token.sh /
RUN chmod +x /token.sh /entrypoint.sh /app_token.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]
