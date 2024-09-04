FROM ubuntu:latest

RUN apt-get update && apt-get install -y --no-install-recommends dumb-init jq

# Install necessary dependencies
RUN apt-get install -y \
    bash \
    curl \
    tar \
    git \
    sudo \
    unzip \
    passwd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /actions-runner

RUN curl -o actions-runner-linux-x64-2.319.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz

RUN tar xzf actions-runner-linux-x64-2.319.1.tar.gz

RUN rm actions-runner-linux-x64-2.319.1.tar.gz

RUN ./bin/installdependencies.sh

RUN mkdir /_work

RUN chown -R runner /_work /actions-runner

COPY entry_point.sh /
RUN chmod +x /entry_point.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./run.py"]
