FROM trieloff/githop:latest

RUN apk add \
        alpine-sdk \
        bash \
        ca-certificates \
        ghc-dev \
        ghc \
        git \
        gmp-dev \
        gnupg \
        libffi-dev \
        linux-headers \
        zlib-dev \
        musl-dev

# cabal         cabal@testing \

RUN curl -O https://www.haskell.org/cabal/release/cabal-install-2.0.0.0/cabal-install-2.0.0.0.tar.gz && \
    tar zxvf cabal-install-2.0.0.0.tar.gz && \
    cd cabal-install-2.0.0.0 && \
    ./bootstrap.sh && \
    cd .. && \
    rm -r cabal-install-2.0.0.0 cabal-install-2.0.0.0.tar.gz 


# upx        upx@testing \

# Haskell stack
RUN curl https://get.haskellstack.org/ | sh

COPY tmux.conf /code/.tmux.conf