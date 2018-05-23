ARG POSTGRES_DB
ARG DISTRO=jessie
FROM python:3.6-$DISTRO

ENV POSTGRES_DB ${POSTGRES_DB}
ENV PG_MAJOR 9.6
ENV PG_VERSION 9.6.*
ENV POSTGIS_VERSION 2.4
ENV DISTRO $DISTRO
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        ntp \
        apt-utils
#
## make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
#RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
#    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
#ENV LANG en_US.utf8

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        postgresql-common \
        postgresql-$PG_MAJOR=$PG_VERSION \
        postgresql-client-$PG_MAJOR=$PG_VERSION \
        postgresql-contrib-$PG_MAJOR=$PG_VERSION \
        postgresql-$PG_MAJOR-postgis-$POSTGIS_VERSION \
        postgresql-$PG_MAJOR-postgis-$POSTGIS_VERSION-scripts \
    && rm "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf" \
    && touch "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf" \
    && chown -R postgres "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf" \
    && chown -R postgres "/var/lib/postgresql/$PG_MAJOR/main/" \
    && { echo; echo "host all all 0.0.0.0/0 trust"; } >> "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf" \
    &&  { echo; echo "local all all trust"; } >> "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf"

# python
#RUN apt-get install -y --no-install-recommends \
#    python-psycopg2 \
#    python-gdal

# system
RUN apt-get install -y --no-install-recommends \
    build-essential \
    apt-utils \
    vim \
    bash \
    git-core

# deps
RUN apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libjpeg-dev \
        libpq-dev\
        gdal-bin \
        libgdal-dev \
        libgdal1h \
        libgdal1-dev \
        libxml2-dev \
        libxslt-dev \
        xmlsec1 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade \
    setuptools \
    pip \
    wheel

RUN mkdir /data

COPY ~entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

ENV PYTHONUNBUFFERED 1
ENV PGHOST "127.0.0.1"
