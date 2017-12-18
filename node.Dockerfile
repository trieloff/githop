FROM githop

RUN apk update && \
    apk add --no-cache nodejs nodejs-npm && \
    rm -f /tmp/* /etc/apk/cache/*
    
COPY tmux.conf /code/.tmux.conf