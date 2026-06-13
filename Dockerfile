FROM python:3.12-slim

RUN pip install --no-cache-dir pre-commit==4.1.0

WORKDIR /workspace

COPY . .

RUN pip install --no-cache-dir -r dev-requirements.txt && pre-commit install

CMD ["bash"]
