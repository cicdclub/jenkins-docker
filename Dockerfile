FROM jenkins/jenkins:lts
USER root
WORKDIR /tmp

# Install Docker, ansible and config Jenkins user
RUN \
  apt-get clean && \
  apt-get update && \
  apt-get install -y \
    curl \
    unzip \
    bzip2 \
    ansible \
    git && \
  wget -qO- https://get.docker.com/ | sh && \
  usermod -aG docker jenkins

# Install Terraform
ENV TERRAFORM_VERSION 0.11.13
RUN \
  curl -s -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  mv terraform /usr/local/bin/ && \
  terraform version

USER jenkins
WORKDIR /var/jenkins_home/

# Install Jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt