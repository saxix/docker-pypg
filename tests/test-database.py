# -*- coding: utf-8 -*-
import psycopg2

connection = psycopg2.connect(database="test", user="postgres", password="")
cursor = connection.cursor()
print("Test database connection and postgis extensions")

cursor.execute("""
  CREATE EXTENSION IF NOT EXISTS dblink; 
  CREATE EXTENSION IF NOT EXISTS postgis; 
  CREATE EXTENSION IF NOT EXISTS postgis_topology;
""")
cursor.execute("DROP TABLE IF EXISTS blocks")
cursor.execute("CREATE TABLE blocks (id SERIAL PRIMARY KEY, "
                                    "fips VARCHAR NOT NULL, "
                                    "pop BIGINT NOT NULL, "
                                    "outline GEOGRAPHY)")


