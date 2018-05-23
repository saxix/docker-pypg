#!/bin/bash
set -ex
#
DATADIR=/var/lib/postgresql/9.6/main

mkdir -p "$DATADIR"
chown -R postgres "$DATADIR" 2>/dev/null || :
chmod 700 "$DATADIR" 2>/dev/null || :

if [ ! -f "$DATADIR/PG_VERSION" ]; then
    su - postgres -c "/usr/lib/postgresql/9.6/bin/initdb $DATADIR --username=postgres"
fi

su - postgres -c "/usr/lib/postgresql/9.6/bin/pg_ctl -D $DATADIR -l logfile start"

if [ -n "$POSTGRES_DB" ]; then
    createdb --username postgres "$POSTGRES_DB"
fi

exec "$@"
