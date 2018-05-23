#!/bin/bash
set -ex
#

export PGDATA=/var/lib/postgresql/9.6/main

mkdir -p "$PGDATA"
chown -R postgres "$PGDATA" 2>/dev/null || :
chmod 700 "$PGDATA" 2>/dev/null || :

if [ ! -f "$PGDATA/PG_VERSION" ]; then
    su - postgres -c "/usr/lib/postgresql/9.6/bin/initdb $PGDATA --username=postgres"
fi

service postgresql start

if [ -n "$POSTGRES_DB" ]; then
    createdb --username postgres "$POSTGRES_DB" 2>/dev/null || :
fi

exec "$@"
