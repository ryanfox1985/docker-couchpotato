FROM gliderlabs/alpine:3.2
MAINTAINER ryanfox1985 <wolf.fox1985@gmail.com>

ENV BUILD_PACKAGES git libffi-dev openssl-dev python-dev sqlite sqlite-dev build-base
ENV PYTHON_PACKAGES python py-pip

# Update and upgrade
RUN apk update
RUN apk upgrade
RUN apk add bash $BUILD_PACKAGES $PYTHON_PACKAGES
RUN pip install --upgrade pip

RUN wget http://nl.alpinelinux.org/alpine/edge/main/x86_64/py-lxml-3.4.0-r0.apk -O /var/cache/apk/py-lxml.apk
RUN apk add --allow-untrusted /var/cache/apk/py-lxml.apk

RUN pip install pyopenssl

ENV APP_HOME /opt/CouchPotatoServer
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Install Sickrage
RUN cd /opt && git clone -b master https://github.com/RuudBurger/CouchPotatoServer.git

# Clean up APT when done.
RUN rm -rf /var/cache/apk/*

EXPOSE 5050
ENTRYPOINT ["python", "CouchPotato.py", "--console_log", "--pid_file=/run/couchpotato.pid", "--data_dir=/config"]
