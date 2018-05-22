#!/bin/bash

sleep 5

su - postgres -c 'psql -U postgres -h 127.0.0.1 -c "CREATE EXTENSION IF NOT EXISTS postgis;"'
su - postgres -c 'psql -U postgres -h 127.0.0.1 -c "CREATE DATABASE test;"'

set -e

pip install -q psycopg2-binary

for py in `ls *.py`; do
    python $py
done
