FROM trieloff/githop:node

RUN apk add \
        rust \
        cargo 

RUN cargo install cargo-generate
        
COPY tmux.conf /code/.tmux.conf