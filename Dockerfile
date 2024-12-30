FROM python:3.8-slim
RUN apt-get update && apt-get install -y r-base && apt-get clean && rm -rf /var/lib/apt/lists/*

