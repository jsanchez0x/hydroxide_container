# BUILDER CONTAINER
FROM golang:1-alpine AS builder

RUN apk --update upgrade && \
    apk add --no-cache --no-progress \
        git \
        make \
        gcc \
        musl-dev && \
    rm -rf /var/cache/apk/*

ENV GOPATH=/go

RUN git -C ./src/ clone https://github.com/emersion/hydroxide.git && \
    cd ./src/hydroxide/cmd/hydroxide && \
    go build . && \
    go install . && \
    cd

# FINAL CONTAINER
FROM alpine:3

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        ca-certificates \
        bash \
        openrc && \
    rm -rf /var/cache/apk/*

COPY --from=builder /go/bin/hydroxide /usr/bin/hydroxide

COPY ./init_hydroxide /usr/local/bin
RUN chmod a+x /usr/local/bin/*

ENTRYPOINT ["init_hydroxide"]