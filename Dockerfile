FROM docker:17.09.1-ce as docker
# Build operator-sdk
FROM stakater/go-dep:1.9.3 as operator-sdk-builder

RUN mkdir -p $GOPATH/src/github.com/operator-framework && \
    cd $GOPATH/src/github.com/operator-framework && \
    git clone https://github.com/operator-framework/operator-sdk && \
    cd operator-sdk && \
    git checkout master && \
    make dep && \
    make install

FROM golang:1.11.0-alpine3.8

COPY --from=operator-sdk-builder /go/bin/operator-sdk /usr/local/bin

COPY --from=docker /usr/local/bin/docker /usr/local/bin/

MAINTAINER Stakater <stakater@gmail.com>

# Update apk repository list in separate layer
# so that install layer does not run everytime
RUN apk update

# This is needed for compatibility with our nodes
ENV DOCKER_API_VERSION=1.32

# Install ansible, boto, aws-cli, and some handy tools
RUN echo "===> Installing Utilities from apk ..."  && \
    apk -v --update --progress add sudo git bash wget openssh groff less python py-pip curl jq unzip nodejs=8.11.4-r0 coreutils python py-pip openssl ca-certificates make sshpass openssh-client rsync gnupg gettext && \
    \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base   && \
    pip install --upgrade pip cffi                              && \
    \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible                && \
    \
    \
    echo "===> Installing Boto..."  && \
    pip install boto3                && \
    \
    \
    echo "===> Installing Aws-Cli..."  && \
    pip install awscli                && \
    \
    \
    echo "===> Installing Awsudo..."  && \
    pip install git+https://github.com/makethunder/awsudo.git  && \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    pip install --upgrade pywinrm                  && \
    \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts

# Install gotpl
ARG GOTPL_VERSION=0.1.5
ARG GOTPL_URL=https://github.com/wodby/gotpl/releases/download/${GOTPL_VERSION}/gotpl-alpine-linux-amd64-${GOTPL_VERSION}.tar.gz
RUN mkdir -p /tmp/gotpl/ && \
    wget ${GOTPL_URL} -O /tmp/gotpl/gotpl.tar.gz && \
    tar -xzvf /tmp/gotpl/gotpl.tar.gz -C /tmp/gotpl/ && \
    mv /tmp/gotpl/gotpl /usr/local/bin/gotplenv

# Install kops, kubectl, and terraform
RUN mkdir -p /aws && \
    curl -LO --show-error https://github.com/kubernetes/kops/releases/download/1.10.0/kops-linux-amd64 && \
    mv kops-linux-amd64 /usr/local/bin/kops && \
    chmod +x /usr/local/bin/kops && \
    curl -LO --show-error https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip && \
    unzip terraform_0.11.8_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_0.11.8_linux_amd64.zip

# Install helm, and landscaper
ARG HELM_VERSION=v2.7.2
ARG HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_URL=http://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME}

ARG LANDSCAPER_VERSION=1.0.12
ARG LANDSCAPER_FILENAME=landscaper-${LANDSCAPER_VERSION}-linux-amd64.tar.gz
ARG LANDSCAPER_URL=https://github.com/Eneco/landscaper/releases/download/${LANDSCAPER_VERSION}/${LANDSCAPER_FILENAME}

RUN curl -L ${HELM_URL} | tar zxv -C /tmp \
    && cp /tmp/linux-amd64/helm /bin/helm \
    && rm -rf /tmp/* \
    && curl -L ${LANDSCAPER_URL} | tar zxv -C /tmp \
    && cp /tmp/landscaper /bin/landscaper \
    && rm -rf /tmp/* \
    && curl https://glide.sh/get | sh \
    && wget https://github.com/stakater/jx-release-version/releases/download/1.1.0/jx-release-version_v1.1.0_Linux_x86_64.tar.gz \
    && tar -xzvf jx-release-version_v1.1.0_Linux_x86_64.tar.gz -C /tmp \
    && cd /tmp \
    && chmod +x jx-release-version \
    && mv jx-release-version /bin/jx-release-version \
    && rm -rf /tmp/* 

ARG GORELEASER_VERSION=v0.79.0
ARG GORELEASER_FILENAME=goreleaser_Linux_x86_64.tar.gz
ARG GORELEASER_URL=https://github.com/goreleaser/goreleaser/releases/download/${GORELEASER_VERSION}/${GORELEASER_FILENAME}

RUN curl -L ${GORELEASER_URL} | tar zxv -C /tmp \
  && cd /tmp \
  && chmod +x goreleaser \
  && mv /tmp/goreleaser /bin/goreleaser \
  && rm -rf /tmp/*

ARG GOLANGCI_VERSION=v1.9.3
ARG GOLANGCI_URL=https://install.goreleaser.com/github.com/golangci/golangci-lint.sh

RUN curl -sfL ${GOLANGCI_URL} | bash -s -- -b /usr/local/bin ${GOLANGCI_VERSION}

ARG DEP_VERSION=v0.5.0
ARG DEP_URL=https://github.com/golang/dep/releases/download/${DEP_VERSION}/dep-linux-386

RUN wget ${DEP_URL} && \
    mv dep-linux-386 /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep

ADD bootstrap.sh /

ADD binaries/* /usr/local/bin/

ENTRYPOINT ["/bootstrap.sh"]
