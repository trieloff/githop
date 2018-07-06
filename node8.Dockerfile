FROM node:8-alpine

FROM trieloff/githop:latest

RUN apk update && \
    apk add --no-cache gcc musl-dev && \
    rm -f /tmp/* /etc/apk/cache/*

COPY --from=0 /usr/local /usr/local
COPY --from=0 /usr/lib /usr/lib
COPY --from=0 /opt /opt

COPY tmux.conf /code/.tmux.conf