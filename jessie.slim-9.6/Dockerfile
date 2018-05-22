FROM debian:jessie-slim

ENV POSTGRES_DB ${POSTGRES_DB}
ENV PG_MAJOR 9.6
ENV PG_VERSION 9.6.*
ENV POSTGIS_VERSION 2.4
ENV PGDATA /var/lib/postgresql/$PG_MAJOR/main
ENV DEBIAN_FRONTEND=noninteractive


RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y --no-install-recommends --fix-missing \
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

## python
#RUN apt-get install -y --no-install-recommends \
#    python3-dev \
#    python-psycopg2 \
#    python-gdal

# system
RUN apt-get install -y --no-install-recommends \
    build-essential \
    apt-utils \
    vim \
    bash \
    git-core

RUN set -ex \
	&& GBUILDDEPS=' \
        ca-certificates \
        wget \
        ' \
    && apt-get update && apt-get install -y $GBUILDDEPS --no-install-recommends  \
    && rm -rf /var/lib/apt/lists/*

# deps
RUN apt-get update && apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libjpeg-dev \
        libpq-dev\
        gdal-bin \
        openssl \
        libssl-dev \
        libgdal-dev \
        libgdal1h \
        libgdal1-dev \
        libxml2-dev \
        libxslt-dev \
        xmlsec1 \
    && rm -rf /var/lib/apt/lists/*

# python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
		tcl \
		tk \
	&& rm -rf /var/lib/apt/lists/*

ENV GPG_KEY 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
ENV PYTHON_VERSION 3.6.5

RUN set -ex \
	&& buildDeps=' \
		dpkg-dev \
		tcl-dev \
		tk-dev \
	' \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	\
	&& wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& rm -rf "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
	&& make -j "$(nproc)" \
	&& make install \
	&& ldconfig \
	\
	&& apt-get purge -y --auto-remove $buildDeps \
	\
	&& find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' + \
	&& rm -rf /usr/src/python

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 10.0.1

RUN set -ex; \
	\
	wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PYTHON_PIP_VERSION" \
	; \
	pip --version; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py

# --------------------------

RUN apt-get purge -y --auto-remove $GBUILDDEPS


RUN pip install --upgrade \
    setuptools \
    pip \
    wheel

#RUN sed -i 's/^host/#host/g' /etc/postgresql/9.4/main/pg_hba.conf
#RUN echo "host  all all 127.0.0.1/32   trust" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN mkdir /data

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

ENV PYTHONUNBUFFERED 1
ENV PGHOST "127.0.0.1"
