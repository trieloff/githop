FROM githop:java

ENV LEIN_VERSION=2.8.1
ENV LEIN_INSTALL=/usr/local/bin/

# Leiningen wants bash
RUN apk update && \
    apk add --no-cache bash && \
    rm -f /tmp/* /etc/apk/cache/*

# Download the whole repo as an archive
RUN mkdir -p $LEIN_INSTALL \
  && curl -OL https://raw.githubusercontent.com/technomancy/leiningen/$LEIN_VERSION/bin/lein-pkg \
  && mv lein-pkg $LEIN_INSTALL/lein \
  && chmod 0755 $LEIN_INSTALL/lein \
  && curl -OL https://github.com/technomancy/leiningen/releases/download/$LEIN_VERSION/leiningen-$LEIN_VERSION-standalone.zip \
  && mkdir -p /usr/share/java \
  && mv leiningen-$LEIN_VERSION-standalone.zip /usr/share/java/leiningen-$LEIN_VERSION-standalone.jar

ENV PATH=$PATH:$LEIN_INSTALL
ENV LEIN_ROOT 1