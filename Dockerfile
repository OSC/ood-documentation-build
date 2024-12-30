FROM alpine:3.20
LABEL maintainer="OSC"

# Set language to avoid bugs that sometimes appear
ENV LANG en_US.UTF-8

# Set up requirements
RUN apk upgrade --update \
    && apk --no-cache add \
          python3 \
          py3-pip \
          make \
          openjdk8-jre \
          ttf-dejavu \
          graphviz \
          ruby ruby-dev yaml-dev g++ make enchant2 aspell-en

# Install PlantUML
RUN apk add --no-cache --virtual .ssl-deps \
      openssl \
      ca-certificates \
    && mkdir -p /opt \
    && wget -O "/opt/plantuml.jar" "https://sourceforge.net/projects/plantuml/files/plantuml.jar" \
    && printf '#!/bin/sh -e\njava -jar /opt/plantuml.jar "$@"' > /usr/local/bin/plantuml \
    && chmod 755 /usr/local/bin/plantuml \
    && apk del .ssl-deps

# Install Sphinx and extras
ADD requirements.txt /tmp/

RUN python3 -m pip install wheel --break-system-packages \
  && python3 -m pip install -r /tmp/requirements.txt --break-system-packages \
  && rm -rf /tmp/requirements.txt

# Add ruby gems we need to build
RUN gem install \
      rdoc rake --no-document

# Stop Java from writing files in documentation source
ENV _JAVA_OPTIONS -Duser.home=/tmp

# Set working directory to documentation root
WORKDIR /doc
