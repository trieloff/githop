FROM trieloff/githop:clojure

# This has Clojure (in case we need Leiningen and ClojureScript)

RUN apk update && \
    apk add --no-cache nodejs nodejs-npm && \
    rm -f /tmp/* /etc/apk/cache/*

RUN npm install -g lumo-cljs --unsafe-perm
RUN npm install -g calvin-cljs
RUN npm install -g closh

RUN curl http://www.antlr.org/download/antlr-4.7.1-complete.jar > /usr/local/lib/antlr-4.7.1-complete.jar

RUN echo -e '#!/bin/sh\njava -jar /usr/local/lib/antlr-4.7.1-complete.jar $@' > /usr/local/bin/antlr4 && \
    chmod +x /usr/local/bin/antlr4

COPY tmux.conf /code/.tmux.conf