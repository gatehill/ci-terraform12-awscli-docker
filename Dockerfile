FROM adoptopenjdk:11-jdk-hotspot

ARG AWSCLI_VER="1.16.118"
ARG COMPOSE_VER="1.23.2"
ARG TERRAFORM_VER="0.12.26"

# Set up directories
RUN mkdir -p ~/.local/bin

RUN apt-get update -y && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        gnupg-agent \
        software-properties-common \
        unzip

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable" && \
    apt-get update -y && \
    apt-get install -y docker-ce-cli

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VER}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install AWS CLI
RUN apt-get install -y python-pip && \
    pip install awscli==${AWSCLI_VER} --upgrade --user

# Install Terraform
RUN mkdir -p ~/.local/bin && \
    cd ~/.local/bin && \
    curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip && \
    unzip *.zip && \
    rm *.zip && \
    chmod +x terraform
