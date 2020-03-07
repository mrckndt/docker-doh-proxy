FROM alpine:latest as rsbuild

RUN apk update && \
    apk add ca-certificates cargo gcc make rust wget && \
    wget https://github.com/jedisct1/rust-doh/archive/0.2.1.tar.gz && \
    mkdir /doh-proxy && \
    tar -zxf *.tar.gz -C /doh-proxy --strip-components=1

WORKDIR /doh-proxy

RUN cargo build --release


FROM alpine:latest

ENV LISTEN_ADDR 0.0.0.0:3000
ENV SERVER_ADDR 9.9.9.9:53
ENV TIMEOUT 10
ENV MAX_CLIENTS 512

EXPOSE 3000/tcp 3000/udp

RUN apk update && apk add libgcc libunwind

COPY --from=rsbuild /doh-proxy/target/release/doh-proxy /usr/local/bin/doh-proxy

CMD ["/bin/sh", "-c", "/usr/local/bin/doh-proxy -l $LISTEN_ADDR -c $MAX_CLIENTS -u $SERVER_ADDR -t $TIMEOUT"]

LABEL maintainer="Marco Kundt"
