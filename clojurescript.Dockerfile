FROM githop:clojure

# This has Clojure (in case we need Leiningen and ClojureScript)

RUN apk update && \
    apk add --no-cache nodejs && \
    rm -f /tmp/* /etc/apk/cache/*

RUN npm install -g shadow-cljs lumo-cljs calvin-cljs closh