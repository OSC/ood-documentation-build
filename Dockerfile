FROM centos:latest
LABEL maintainer="OSC"

# Set language to avoid bugs that sometimes appear
ENV LANG en_US.UTF-8

# Set up requirements
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - \
    && yum -y install \	   
       openjdk8-jre \
       ttf-dejavu \
       graphviz \
       alsa-lib \
       gtk3 \
       libXScrnSaver \
       libappindicator \
       libnotify \
       git \
       wget \
       openssl \
       nodejs \
       npm \
       which \
       gcc-c++ make \
       epel-release \
    && yum clean all \
    && rm -rf /var/cache/yum

# Install PlantUML
RUN mkdir -p /opt \
    && wget -O "/opt/plantuml.jar" "https://sourceforge.net/projects/plantuml/files/plantuml.jar" \
    && printf '#!/bin/sh -e\njava -jar /opt/plantuml.jar "$@"' > /usr/local/bin/plantuml \
    && chmod 755 /usr/local/bin/plantuml 

# Install Sphinx and extras
ADD Pipfile* /tmp/

# Install pipenv
RUN yum install -y python36-pip.noarch \
    && pip3 install pipenv=='2018.11.26' \
    && cd /tmp \
    && pipenv install --deploy --system \ 
    && rm -rf /tmp/Pipfile* \
    && yum clean all \
    && rm -rf /var/cache/yum

# Install drawio-batch
RUN git clone "https://github.com/languitar/drawio-batch.git" \
    && cd drawio-batch && npm -g install && npm install \
    && yum clean all \
    && rm -rf /var/cache/yum 

# Stop Java from writing files in documentation source
ENV _JAVA_OPTIONS -Duser.home=/tmp

# Set working directory to documentation root
WORKDIR /doc

