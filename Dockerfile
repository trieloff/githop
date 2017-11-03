FROM alpine

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update && \
    apk add --no-cache zsh git curl jq openssh-client micro@testing samba samba-common-tools && \
    rm -f /tmp/* /etc/apk/cache/*

# RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd
RUN curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | zsh || true

ENV SHELL /bin/zsh
COPY zshrc /root/.zshrc
COPY lessfilter /root/.lessfilter
COPY gitconfig /root/.gitconfig
COPY known_hosts /root/.ssh/known_hosts
COPY smb.conf /etc/samba/smb.conf

COPY lesspipe.sh /usr/bin/lesspipe.sh
COPY code2color /usr/bin/code2color
COPY githop-fetch /usr/bin/githop
COPY setsmbpassword /usr/bin/setsmbpassword
RUN chmod +x /usr/bin/githop /root/.lessfilter /usr/bin/lesspipe.sh /usr/bin/code2color /usr/bin/setsmbpassword

EXPOSE 139
EXPOSE 445

WORKDIR /code
ENTRYPOINT ["/bin/zsh"]