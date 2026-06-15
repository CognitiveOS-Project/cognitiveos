FROM alpine:latest

WORKDIR /workspace

COPY . .

RUN apt update && apt add git curl docker-cli && \
    git init && \
    pip install --no-cache-dir -r dev-requirements.txt && \
    pre-commit install

CMD ["bash"]
