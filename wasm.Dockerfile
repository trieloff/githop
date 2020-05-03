FROM trieloff/githop:node

RUN apk add \
        rust \
        cargo 

RUN cargo install \
        cargo-generate \
        wasm-pack
        
COPY tmux.conf /code/.tmux.conf