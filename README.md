## rust-doh

This runs rust-doh (https://github.com/jedisct1/rust-doh) as a dns proxy at port 3000 for using DNS over HTTPS. By default the resulting container will use Quad9 as resolver but you should be able to use any DoH supporting server (or your own resolver with Unbound e.g. https://www.bentasker.co.uk/documentation/linux/407-building-and-running-your-own-dns-over-https-server). For a good list take a look [here](https://github.com/curl/curl/wiki/DNS-over-HTTPS).

### Running the container
#### Using defaults
```docker run --name rust-doh --rm --net host flexo3001/rust-doh```

The default options are (which you can override with -e option):

```
ENV LISTEN_ADDR 127.0.0.1:3000
ENV SERVER_ADDR 9.9.9.9:53
ENV BIND_ADDR 0.0.0.0:0
ENV ERR_TTL 2
ENV MAX_TTL 604800
ENV MIN_TTL 10
ENV LOCATION_PATH /dns-query
ENV TIMEOUT 10
ENV MAX_CLIENTS 512
```
