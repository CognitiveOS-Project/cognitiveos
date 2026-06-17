FROM python:3.13

WORKDIR /workspace
VOLUME "/workspace"

COPY . .

# Install bash, git, curl, and docker tools from Docker official repo
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    git \
    curl \
    ca-certificates \
    gnupg && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian trixie stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin && \
    git init && \
    pip install --no-cache-dir --break-system-packages -r dev-requirements.txt && \
    pre-commit install

CMD ["bash"]
