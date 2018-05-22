#!/usr/bin/env bash
set -ex

DATADIR=/var/lib/postgresql/9.6/main
if [ ! -f "$DATADIR/PG_VERSION" ]; then
    mkdir -p "$DATADIR"
    chown -R postgres "$DATADIR" 2>/dev/null || :
    chmod 700 "$DATADIR" 2>/dev/null || :
    su - postgres -c "/usr/lib/postgresql/9.6/bin/initdb $DATADIR --username=postgres"
    service postgresql start
    createdb --username postgres vareda
else
    service postgresql start
fi


if [ -n "$POSTGRES_DB" ]; then
    createdb --username postgres "$POSTGRES_DB"
fi

exec "$@"