FROM theelves/elvish AS elvish
FROM alpine:3.11.2

LABEL author="Lars Trieloff <lars@trieloff.net>" 

ENV BUILDDEPS="curl build-base automake autoconf libtool avahi-dev libgcrypt-dev linux-pam-dev cracklib-dev db-dev libevent-dev krb5-dev tdb-dev file cargo cmake"
ENV RUNTIMEDEPS="avahi libldap libgcrypt python avahi dbus dbus-glib py-dbus linux-pam cracklib db libevent krb5 tdb"

RUN apk --no-cache add $BUILDDEPS $RUNTIMEDEPS

# exa, a modern replacement for ls

RUN mkdir -p /build/exa \
  && curl -Ls https://github.com/ogham/exa/archive/v0.9.0.tar.gz | tar zx -C /build/exa --strip-components=1

RUN cd /build/exa \
  && RUSTFLAGS="-C target-feature=-crt-static" cargo build --release --verbose

RUN cd /build/exa \
  && install -m755 -D target/release/exa "/usr/bin/exa" \ 
  && install -m644 -D contrib/completions.zsh "/usr/share/zsh/site-functions/_exa"

# elvish shell

#RUN mkdir -p /build/elvish \
#  && curl -Ls https://github.com/elves/elvish/archive/v0.8.tar.gz | tar zx -C /build/elvish --strip-components=1
#
#RUN cd /build/elvish \
#  && exa \
#  && go build -o bin/elvish \
#  && exa bin
#
#RUN cd /build/elvish \
#  && install -m 755 -D bin/elvish /usr/bin/elvish

COPY --from=elvish /bin/elvish /bin/elvish

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
    && mkdir /media/share

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "@community http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk update && \
    apk add --no-cache zsh curl jq openssh-client tmux micro@testing zip file git tig less bash asciinema httpie@community py-pip man-pages man mdocml-apropos less less-doc && \
    rm -f /tmp/* /etc/apk/cache/*

# RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd
RUN git --version && curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh || true

RUN curl -L -O https://github.com/sharkdp/bat/releases/download/v0.12.1/bat-v0.12.1-x86_64-unknown-linux-musl.tar.gz && tar zxvf bat-v0.12.1-x86_64-unknown-linux-musl.tar.gz && mv bat-v0.12.1-x86_64-unknown-linux-musl/bat /usr/bin && rm -r bat-v0.12.1-x86_64-unknown-linux-musl*

RUN pip install mdv
RUN pip install git+https://github.com/jeffkaufman/icdiff.git
RUN pip install tldr
RUN pip3 install commitizen

ENV SHELL /bin/elvish
# Default to UTF-8 file.encoding
#ENV LANG C.UTF-8

COPY zshrc /root/.zshrc
COPY lessfilter /root/.lessfilter

COPY lesspipe.sh /usr/bin/lesspipe.sh
COPY code2color /usr/bin/code2color
COPY githop-fetch /usr/bin/githop
COPY git-cz /usr/bin/git-cz
COPY tmux.conf /root/.tmux.conf
RUN chmod +x /usr/bin/git-cz
COPY tigrc /root/.tigrc
RUN mkdir /root/.elvish
COPY rc.elv /root/.elvish/rc.elv
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
RUN cp -r /root/.elvish /code/.elvish
COPY tmux.conf /code/.tmux.conf
COPY tigrc /code/.tigrc

RUN git clone https://github.com/tmux-plugins/tpm /code/.tmux/plugins/tpm

RUN curl -OLs https://github.com/apache/openwhisk-cli/releases/download/1.0.0/OpenWhisk_CLI-1.0.0-linux-386.tgz && \
    tar -zxvf OpenWhisk_CLI-1.0.0-linux-386.tgz && \
    mv wsk /usr/bin/wsk && \
    rm OpenWhisk_CLI-1.0.0-linux-386.tgz

COPY cistatus.sh /usr/bin/cistatus
RUN chmod +x /usr/bin/cistatus

RUN git clone https://github.com/zsh-users/zsh-autosuggestions /code/.oh-my-zsh/custom/plugins/zsh-autosuggestions

RUN chown -R afp /code

WORKDIR /code
ENTRYPOINT ["su", "-", "afp", "-c", "/usr/bin/tmux -u2"]
