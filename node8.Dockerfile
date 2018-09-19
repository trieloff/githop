FROM node:8-alpine

FROM trieloff/githop:latest

RUN apk update && \
    apk add --no-cache gcc musl-dev openssl-dev libgit2-dev curl-dev && \
    rm -f /tmp/* /etc/apk/cache/*

RUN ln -s /usr/lib/libcurl.so.4 /usr/lib/libcurl-gnutls.so.4
RUN mkdir /code/.npm-global

COPY --from=0 /usr/local /usr/local
COPY --from=0 /usr/lib /usr/lib
COPY --from=0 /opt /opt

COPY tmux.conf /code/.tmux.conf