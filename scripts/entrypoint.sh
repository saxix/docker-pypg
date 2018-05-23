#!/bin/bash
set -ex
#

export PGDATA=/var/lib/postgresql/9.6/main
mkdir -p /docker-entrypoint.d

mkdir -p "$PGDATA"
chown -R postgres "$PGDATA" 2>/dev/null || :
chmod 700 "$PGDATA" 2>/dev/null || :

if [ ! -f "$PGDATA/PG_VERSION" ]; then
    su - postgres -c "/usr/lib/postgresql/9.6/bin/initdb $PGDATA --username=postgres"
fi

service postgresql start

echo
for f in /docker-entrypoint.d/*; do
    case "$f" in
        *.py)     echo "$0: running $f"; "/bin/bash $f" ;;
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.sql)    echo "$0: running $f"; "${psql[@]}" -f "$f"; echo ;;
        *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${psql[@]}"; echo ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done


if [ -n "$POSTGRES_DB" ]; then
    createdb --username postgres "$POSTGRES_DB" 2>/dev/null || :
fi

exec "$@"
