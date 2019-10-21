FROM alpine:latest AS build-env

# Install PlantUML
RUN apk add --no-cache --virtual .ssl-deps \
    openssl \
    ca-certificates \
    && mkdir -p /opt \
    && wget -O "/opt/plantuml.jar" "https://sourceforge.net/projects/plantuml/files/plantuml.jar" \
    && printf '#!/bin/sh -e\njava -jar /opt/plantuml.jar "$@"' > /usr/local/bin/plantuml \
    && chmod 755 /usr/local/bin/plantuml \
    && apk del .ssl-deps

FROM centos:7
LABEL maintainer="OSC"

# Set language to avoid bugs that sometimes appear
ENV LANG en_US.UTF-8

# Install sphinx (No need for a multi stage here as there is no build needed)
RUN curl -o sphinx-build -L https://github.com/trustin/sphinx-binary/releases/download/v0.5.0/sphinx.linux-x86_64 \
    && chmod +x sphinx-build  \   
    && mv sphinx-build /usr/local/sbin/sphinx-build \
    && yum clean all \
    && rm -rf /var/cache/yum

# Install drawio-desktop
RUN curl -OL https://github.com/jgraph/drawio-desktop/releases/download/v12.1.0/draw.io-x86_64-12.1.0.rpm 

# Install drawio-desktop & PlantUML dependencies 
RUN yum install -y at-spi2-core gtk3 libXScrnSaver libnotify libXtst nss xdg-utils \
       alsa-lib.x86_64 make graphviz java-11-openjdk.x86_64 dejavu-sans-mono-fonts.noarch python3.x86_64 \
    && rpm --install draw.io-x86_64-12.1.0.rpm \
    && rm draw.io-x86_64-12.1.0.rpm \
    && yum clean all \
    && rm -rf /var/cache/yum

# Stop Java from writing files in documentation source
ENV _JAVA_OPTIONS -Duser.home=/tmp

# Copy from Alpine the installed PlantUML file into Centos
COPY --from=build-env /usr/local/bin/plantuml /usr/local/bin/plantuml
COPY --from=build-env /opt/plantuml.jar /opt/plantuml.jar

# Set working directory to documentation root
WORKDIR /doc
