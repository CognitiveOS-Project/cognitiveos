FROM alpine:latest

WORKDIR /workspace

COPY . .

RUN apt-get update && apt-get install -y git && \
    git init && \
    pip install --no-cache-dir -r dev-requirements.txt && \
    pre-commit install

CMD ["bash"]
