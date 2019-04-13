FROM node:10-alpine

FROM trieloff/githop:latest

RUN apk update && \
    apk add --no-cache gcc musl-dev openssl-dev libgit2-dev curl-dev zsh-vcs && \
    rm -f /tmp/* /etc/apk/cache/*

RUN ln -s /usr/lib/libcurl.so.4 /usr/lib/libcurl-gnutls.so.4
RUN mkdir /code/.npm-global

COPY --from=0 /usr/local /usr/local
COPY --from=0 /usr/lib /usr/lib
COPY --from=0 /opt /opt

RUN npm install -g npm@latest
RUN npm i -g gh
RUN ln -s /usr/local/bin/node /usr/bin/node
RUN ln -s /usr/local/bin/npm /usr/bin/npm
RUN su - afp -c "/usr/local/bin/npm i @adobe/helix-cli"
RUN mkdir -p /usr/local/node_modules/hlx && mv /code/node_modules /usr/local/node_modules/hlx && ln -s /usr/local/node_modules/hlx/node_modules/.bin/hlx /usr/local/bin/hlx

RUN git clone https://github.com/denysdovhan/spaceship-prompt.git /code/.oh-my-zsh/custom/themes/spaceship-prompt
RUN ln -s "/code/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "/code/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

COPY tmux.conf /code/.tmux.conf