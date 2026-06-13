FROM python:3.12-slim

RUN apt-get update && apt-get install -y git && \
    git init && \
    pip install --no-cache-dir -r dev-requirements.txt && \
    pre-commit install
    
WORKDIR /workspace

COPY . .

RUN pip install --no-cache-dir -r dev-requirements.txt && pre-commit install

CMD ["bash"]
