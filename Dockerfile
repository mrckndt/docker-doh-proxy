FROM alpine:latest as rsbuild

RUN apk update && \
    apk add ca-certificates cargo gcc make rust && \
    mkdir /doh-proxy && \
    cargo install --root /doh-proxy doh-proxy

FROM alpine:latest

ARG PUID=2000
ARG PGID=2000

ENV LISTEN_ADDR 0.0.0.0:3000
ENV SERVER_ADDR 9.9.9.9:53
ENV TIMEOUT 10
ENV MAX_CLIENTS 512
ENV SUBPATH /dns-query

EXPOSE 3000/tcp

RUN apk update && apk add libgcc libunwind && \
    addgroup -g ${PGID} doh-proxy && \
    adduser -H -D -u ${PUID} -G doh-proxy doh-proxy

COPY --from=rsbuild /doh-proxy/bin/doh-proxy /usr/local/bin/doh-proxy

USER doh-proxy

CMD ["/bin/sh", "-c", "/usr/local/bin/doh-proxy -l $LISTEN_ADDR -c $MAX_CLIENTS -u $SERVER_ADDR -t $TIMEOUT -p $SUBPATH"]
