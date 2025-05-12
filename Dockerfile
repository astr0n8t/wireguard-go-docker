ARG GOLANG_VERSION=1.20
ARG ALPINE_VERSION=3.19

FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} AS builder

ARG wg_go_tag=0.0.20230223
ARG wg_tools_tag=v1.0.20210914

RUN apk add --update git build-base libmnl-dev

RUN git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    git checkout $wg_go_tag && \
    make && \
    make install

ENV WITH_WGQUICK=yes
RUN git clone https://git.zx2c4.com/wireguard-tools && \
    cd wireguard-tools && \
    git checkout $wg_tools_tag && \
    cd src && \
    make && \
    make install

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache --update bash openresolv iproute2

COPY --from=builder /usr/bin/wireguard-go /usr/bin/wg* /usr/bin/
COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
