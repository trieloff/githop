FROM trieloff/githop:latest

RUN apk add \
        rust \
        cargo
        
COPY tmux.conf /code/.tmux.conf