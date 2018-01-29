FROM stakater/base-alpine:3.7

MAINTAINER Stakater <stakater@gmail.com>

RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
    apk --update add sudo                                         && \
    \
    \
    echo "===> Adding Python runtime..."  && \
    apk --update add python py-pip openssl ca-certificates    && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi                            && \
    \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible                && \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    pip install --upgrade pywinrm                  && \
    apk --update add sshpass openssh-client rsync  && \
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


RUN pip install boto

RUN mkdir -p /aws && \
    apk -Uuv add git openssh groff less python py-pip curl jq unzip && \
    curl -LO --show-error https://github.com/kubernetes/kops/releases/download/1.8.0/kops-linux-amd64 && \
    mv kops-linux-amd64 /usr/local/bin/kops && \
    chmod +x /usr/local/bin/kops && \
    curl -LO --show-error https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    wget https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip && \
    unzip terraform_0.11.1_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_0.11.1_linux_amd64.zip && \
    pip install awscli boto && \
    apk --purge -v del py-pip && \
    rm /var/cache/apk/*

ARG HELM_VERSION=v2.7.2
ARG HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz
ARG HELM_URL=http://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME}

ARG LANDSCAPER_VERSION=1.0.12
ARG LANDSCAPER_FILENAME=landscaper-${LANDSCAPER_VERSION}-linux-amd64.tar.gz
ARG LANDSCAPER_URL=https://github.com/Eneco/landscaper/releases/download/${LANDSCAPER_VERSION}/${LANDSCAPER_FILENAME}

RUN mkdir -p /aws && \
    apk -Uuv add git openssh groff less python py-pip curl jq && \
    curl -LO --show-error https://github.com/kubernetes/kops/releases/download/1.8.0/kops-linux-amd64 && \
    mv kops-linux-amd64 /usr/local/bin/kops && \
    chmod +x /usr/local/bin/kops && \
    curl -LO --show-error https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    pip install awscli boto && \
    apk --purge -v del py-pip && \
    rm /var/cache/apk/*

# Install helm
RUN curl -L ${HELM_URL} | tar zxv -C /tmp \
    && cp /tmp/linux-amd64/helm /bin/helm \
    && rm -rf /tmp/*

# Install landscaper
RUN curl -L ${LANDSCAPER_URL} | tar zxv -C /tmp \
    && cp /tmp/landscaper /bin/landscaper \
    && rm -rf /tmp/*

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
