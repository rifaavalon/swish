FROM python:3.10-slim
RUN apt-get update && apt-get install -y r-base && apt-get clean && rm -rf /var/lib/apt/lists/*

