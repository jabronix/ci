ARG version=latest

FROM ubuntu:$version as base
LABEL authors="Jabronix"

ENV ATLANTIS_DEFAULT_TF_VERSION="0.12.24"

WORKDIR /home/temp
RUN ls -la
COPY scripts/packages.sh ./
COPY scripts/cleanup.sh ./
RUN chmod +x packages.sh && \
    ./packages.sh


COPY scripts/binaries.sh ./
COPY scripts/cleanup.sh ./
RUN chmod +x binaries.sh && \
    ./binaries.sh


RUN wget https://releases.hashicorp.com/terraform/${ATLANTIS_DEFAULT_TF_VERSION}/terraform_${ATLANTIS_DEFAULT_TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${ATLANTIS_DEFAULT_TF_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/

ENV LANG C.UTF-8

USER dev
WORKDIR /home/dev

ENV PATH=/home/dev/bin:$PATH:/sbin

COPY scripts/.zshrc ./home/dev
COPY scripts/user-helpers.sh ./
COPY scripts/cleanup.sh ./
RUN sudo chmod +x user-helpers.sh && \
    ./user-helpers.sh

COPY scripts/.zshrc /home/dev/.zshrc

USER atlantis

ENV LANG C.UTF-8

ENV PATH=/home/dev/bin:$PATH:/sbin:/usr/local/go/bin

RUN go get -u github.com/liamg/tfsec/cmd/tfsec && \
    mkdir -p /home/atlantis/bin/

COPY scripts/.bashrc /home/atlantis/.bashrc
COPY config/server-config.yaml /home/atlantis/server-config
COPY config/repo-config.yaml /home/atlantis/repo-config

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD /usr/bin/atlantis server --config=${HOME}/server-config.yaml --repo-config=${HOME}/repo-config.yaml
