FROM golang:1.16.0-alpine

# Update packages
RUN apk update && \
    apk add --no-cache \
    curl \
    bash \
    python3 \
    python3-dev \
    py3-pip \
    gcc \
    g++

RUN pip install awscli
RUN pip install aws-sam-cli

WORKDIR /go/src/amazon-ecs-continuous-scan
COPY . /go/src/amazon-ecs-continuous-scan/

# go mod download
RUN go mod download
