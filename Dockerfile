FROM rust:slim-bullseye as rsbuild

RUN apt update && \
    apt install -y --no-install-recommends ca-certificates gcc make && \
    mkdir /doh-proxy && \
    cargo install --root /doh-proxy doh-proxy


FROM debian:bullseye-slim

ARG PUID=2000
ARG PGID=2000

ENV LISTEN_ADDR 0.0.0.0:3000
ENV SERVER_ADDR 9.9.9.9:53
ENV TIMEOUT 10
ENV MAX_CLIENTS 512

EXPOSE 3000/tcp

RUN groupadd -g ${PGID} doh-proxy && \
    adduser --no-create-home --disabled-login --uid ${PUID} --gid ${PGID} doh-proxy

COPY --from=rsbuild /doh-proxy/bin/doh-proxy /usr/local/bin/doh-proxy

USER doh-proxy

CMD ["/bin/sh", "-c", "/usr/local/bin/doh-proxy -l $LISTEN_ADDR -c $MAX_CLIENTS -u $SERVER_ADDR -t $TIMEOUT"]
