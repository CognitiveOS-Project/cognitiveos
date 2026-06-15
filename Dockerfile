FROM alpine:latest

WORKDIR /workspace

COPY . .

# Install bash, git, curl, docker-cli, and python3/pip
RUN apk update && apk add --no-cache \
    bash \
    git \
    curl \
    docker-cli \
    python3 \
    py3-pip && \
    git init && \
    pip install --no-cache-dir --break-system-packages -r dev-requirements.txt && \
    pre-commit install

CMD ["bash"]
