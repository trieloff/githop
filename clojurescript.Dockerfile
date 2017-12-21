FROM trieloff/githop:clojure

# This has Clojure (in case we need Leiningen and ClojureScript)

RUN apk update && \
    apk add --no-cache nodejs nodejs-npm && \
    rm -f /tmp/* /etc/apk/cache/*

RUN npm install -g lumo-cljs
RUN npm install -g calvin-cljs
RUN npm install -g closh

COPY tmux.conf /code/.tmux.conf