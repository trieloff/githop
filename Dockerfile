FROM alpine:latest

LABEL author="Lars Trieloff <lars@trieloff.net>" 

ENV BUILDDEPS="curl build-base automake autoconf libtool avahi-dev libgcrypt-dev linux-pam-dev cracklib-dev db-dev libevent-dev krb5-dev tdb-dev file"
ENV RUNTIMEDEPS="avahi libldap libgcrypt python avahi dbus dbus-glib py-dbus linux-pam cracklib db libevent krb5 tdb"

RUN apk --no-cache add $BUILDDEPS $RUNTIMEDEPS
RUN mkdir -p /build/netatalk \
    && curl -Ls https://github.com/Netatalk/Netatalk/archive/netatalk-3-1-10.tar.gz | tar zx -C /build/netatalk --strip-components=1
RUN cd /build/netatalk \
    && ./bootstrap \
    && ./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --with-init-style=debian-sysv \
    --without-libevent \
    --without-tdb \
    --with-cracklib \
    --enable-krbV-uam \
    --with-pam-confdir=/etc/pam.d \
    --with-dbus-sysconf-dir=/etc/dbus-1/system.d \
    --with-tracker-pkgconfig-version=0.16 \
    && make \
    && make install \
    && cd / && rm -rf /build \
    && mkdir /media/share \
    && apk del --purge $BUILDDEPS

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update && \
    apk add --no-cache zsh git curl jq openssh-client tmux micro@testing zip file tig && \
    rm -f /tmp/* /etc/apk/cache/*

# RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd
RUN curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | zsh || true

RUN curl -L -O https://github.com/sharkdp/bat/releases/download/v0.2.3/bat-v0.2.3-x86_64-unknown-linux-musl.tar.gz && tar zxvf bat-v0.2.3-x86_64-unknown-linux-musl.tar.gz && mv bat-v0.2.3-x86_64-unknown-linux-musl/bat /usr/bin && rm -r bat-v0.2.3-x86_64-unknown-linux-musl*





ENV SHELL /bin/zsh
# Default to UTF-8 file.encoding
#ENV LANG C.UTF-8

COPY zshrc /root/.zshrc
COPY lessfilter /root/.lessfilter

COPY lesspipe.sh /usr/bin/lesspipe.sh
COPY code2color /usr/bin/code2color
COPY githop-fetch /usr/bin/githop
COPY tmux.conf /root/.tmux.conf
COPY tigrc /root/.tigrc
RUN chmod +x /usr/bin/githop /root/.lessfilter /usr/bin/lesspipe.sh /usr/bin/code2color
RUN mkdir /root/.ssh
RUN mkdir /root/.m2

RUN mkdir /code
RUN adduser -D -h /code afp
RUN mkdir -p /code/.m2
RUN mkdir /code/.ssh
RUN cp /root/.zshrc /code/.zshrc
RUN cp -r /root/.oh-my-zsh /code/.oh-my-zsh
RUN cp /root/.lessfilter /code/.lessfilter
COPY tmux.conf /code/.tmux.conf
COPY tigrc /code/.tigrc

RUN curl -OLs https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz && \
    tar -zxvf OpenWhisk_CLI-latest-linux-386.tgz && \
    mv wsk /usr/bin/wsk && \
    rm OpenWhisk_CLI-latest-linux-386.tgz

COPY cistatus.sh /usr/bin/cistatus
RUN chmod +x /usr/bin/cistatus

WORKDIR /code
ENTRYPOINT ["su", "-", "afp", "-c", "/usr/bin/tmux -u2"]
