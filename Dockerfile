FROM centos:7
LABEL maintainer="OSC"

# Set up requirements
RUN yum -y install \	   
          make \
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
    && curl -sL https://rpm.nodesource.com/setup_10.x | bash - \
    && yum install -y  nodejs 
	
# Install PlantUML
RUN mkdir -p /opt \
    && wget -O "/opt/plantuml.jar" "https://sourceforge.net/projects/plantuml/files/plantuml.jar" \
    && printf '#!/bin/sh -e\njava -jar /opt/plantuml.jar "$@"' > /usr/local/bin/plantuml \
    && chmod 755 /usr/local/bin/plantuml 

# Install Sphinx and extras
ADD Pipfile* /tmp/

RUN yum install -y epel-release && yum install -y  python36-pip.noarch \ 
    && export LC_ALL=en_US.utf8 && export LANG=en_US.utf8 \  
    && pip3 install pipenv=='2018.11.26' \
    && cd /tmp \
    && pipenv install --deploy --system \ 
    && rm -rf /tmp/Pipfile*

# Install drawio-batch && build *.drawio files
RUN git clone "https://github.com/languitar/drawio-batch.git" \
    && cd  drawio-batch && npm -g install && npm install  

# Stop Java from writing files in documentation source
ENV _JAVA_OPTIONS -Duser.home=/tmp

# Set working directory to documentation root
WORKDIR /doc
