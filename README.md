### 1. Introduction
This docker image contains all the tools required for pipelines we use in stakater.

### 2. Context
This repo is part of a parent project to achieve the ability of possibility of controlled deployments in different environments so, that we can rollback when needed.

#### Tools included

##### Apk packages

* python
* py-pip
* openssl
* ca-certificates
* python-dev
* libffi-dev
* openssl-dev
* build-base
* sshpass
* openssh-client
* rsync
* del
* build-dependencies
* git
* openssh
* groff
* less
* python
* curl
* jq
* unzip
* make
* nodejs 8.12.0-r0

##### PIP packages

* pip
* cffi
* ansible
* boto
* awscli
* pywinrm

##### Other Binaries

* https://github.com/kubernetes/kops/releases/download/1.8.1/kops-linux-amd64
* https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl
* https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
* http://storage.googleapis.com/kubernetes-helm/helm-v2.7.2-linux-amd64.tar.gz
* https://github.com/Eneco/landscaper/releases/download/1.0.12/landscaper-1.0.12-linux-amd64.tar.gz
* https://github.com/wodby/gotpl
* https://install.goreleaser.com/github.com/golangci/golangci-lint.sh
* https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-386

##### Infrastructure

This image can be run from any type of host which supports docker with no platform restrictions. However, it was originally intended to be used by a Jenkins job.

### 3. Running 

Pull:

`docker pull stakater/pipeline-tools`

Run:

`docker run -it stakater/pipeline-tools:1.0.1 sh`

### 4. Help 

**Got a question?** 
File a GitHub [issue](https://github.com/stakater/dockerfile-fluentd-kubernetes/issues), send us an [email](stakater@gmail.com).

### 5. Contributing 


#### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/stakater/dockerfile-fluentd-kubernetes/issues) to report any bugs or file feature requests.

#### Developing

PRs are welcome. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

### 6. Changelog 

View our closed [Pull Requests](https://github.com/stakater/dockerfile-fluentd-kubernetes/pulls?q=is%3Apr+is%3Aclosed).

### 7. License 

Apache2 © [Stakater](https://stakater.com)
