FROM githop

RUN apk update && \
    apk add --no-cache nodejs nodejs-npm && \
    rm -f /tmp/* /etc/apk/cache/*