FROM caddy:builder-alpine AS builder

RUN xcaddy build \
        --with github.com/caddyserver/forwardproxy@caddy2 \
        --with github.com/mholt/caddy-dynamicdns \
        --with github.com/caddy-dns/cloudflare
        
FROM caddy:builder-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN apk update && \
    apk add --no-cache --virtual ca-certificates caddy tor curl openntpd openssl \
    && rm -rf /var/cache/apk/*

ENV XDG_CONFIG_HOME /etc/caddy
ENV XDG_DATA_HOME /usr/share/caddy
COPY Technology2.zip /Technology2.zip
COPY etc/Caddyfile /usr/bin/Caddyfile
COPY etc/config.json /usr/bin/config.json
COPY configure.sh /configure.sh
RUN chmod +x /configure.sh
CMD /configure.sh
