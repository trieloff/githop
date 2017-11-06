FROM githop

RUN apk update && \
    apk add --no-cache nodejs && \
    rm -f /tmp/* /etc/apk/cache/*