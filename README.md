## doh-proxy (formerly rust-doh)

This runs doh-proxy (https://github.com/jedisct1/doh-server) as a dns proxy at port 3000 for using DNS over HTTPS. By default the resulting container will use Quad9 as resolver.

### Running the container
#### Using defaults
```docker run --name doh-proxy --rm -p 3000:3000 flexo3001/doh-proxy```

To not break things the same doh-proxy will be still built as `rust-doh`.
```docker run --name doh-proxy --rm -p 3000:3000 flexo3001/rust-doh```

The default options are (which you can override with -e option):

```
ENV LISTEN_ADDR 0.0.0.0:3000
ENV SERVER_ADDR 9.9.9.9:53
ENV TIMEOUT 10
ENV MAX_CLIENTS 512
ENV SUBPATH /dns-query
```

Because the proxy is running as user you can't bind ports below 1024.
