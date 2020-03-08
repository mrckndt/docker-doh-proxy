## rust-doh

This runs rust-doh (https://github.com/jedisct1/rust-doh) as a dns proxy at port 3000 for using DNS over HTTPS. By default the resulting container will use Quad9 as resolver.

### Running the container
#### Using defaults
```docker run --name rust-doh --rm -p 3000:3000 flexo3001/rust-doh```

The default options are (which you can override with -e option):

```
ENV LISTEN_ADDR 0.0.0.0:3000
ENV SERVER_ADDR 9.9.9.9:53
ENV TIMEOUT 10
ENV MAX_CLIENTS 512
```
