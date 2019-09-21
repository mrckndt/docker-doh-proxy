FROM alpine:edge as rsbuild

RUN apk update && apk add ca-certificates cargo gcc git make rust && git clone https://github.com/jedisct1/rust-doh /rust-doh

WORKDIR /rust-doh

RUN cargo build --release


FROM alpine:latest

ENV PORT 3000
ENV LISTEN_ADDR 127.0.0.1:3000
ENV SERVER_ADDR 9.9.9.9:53
ENV BIND_ADDR 0.0.0.0:0
ENV ERR_TTL 2
ENV MAX_TTL 604800
ENV MIN_TTL 10
ENV LOCATION_PATH /dns-query
ENV TIMEOUT 10
ENV MAX_CLIENTS 512

EXPOSE $PORT/tcp $PORT/udp

RUN apk update && apk add libgcc libunwind

COPY --from=rsbuild /rust-doh/target/release/doh-proxy /usr/local/bin/doh-proxy

CMD ["/bin/sh", "-c", "/usr/local/bin/doh-proxy -E $ERR_TTL -l $LISTEN_ADDR -b $BIND_ADDR -c $MAX_CLIENTS -X $MAX_TTL -T $MIN_TTL -p $LOCATION_PATH -u $SERVER_ADDR -t $TIMEOUT"]

LABEL maintainer="Marco Kundt"
