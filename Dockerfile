# Download base image
FROM python:3.10.6

# LABEL about the custom image
LABEL maintainer="3roin"
LABEL version="1.0.0"
LABEL description="ansible docker image"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Copy requirements for python and ansible
COPY python3_requirements.txt ansible_roles_requirements.yml ansible_collections_requirements.yml ./

# Install pip packages

RUN pip install --no-cache-dir -r python3_requirements.txt

# Install Ansible Galaxy collections and roles

RUN ansible-galaxy install -r ansible_roles_requirements.yml && \
    ansible-galaxy collection install -r ansible_collections_requirements.yml

# Install linux packages

RUN apt-get update && \
    apt-get install -qy sshpass && \
    apt-get install -qy net-tools

# Post-installation cleanup
RUN apt-get -qy autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
