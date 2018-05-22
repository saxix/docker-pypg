saxix/pypg
----------


[![Build Status](https://travis-ci.org/saxix/docker-pypg.svg)](https://travis-ci.org/saxix/docker-pypg)

The `saxix/pypg` image provides a Docker container running Python 3.6 Postgres 9 with [PostGIS 2.4](http://postgis.net/) installed.
These image are based on the official [`debian`](https://registry.hub.docker.com/_/debian/) images (standard and slim)

The image ensure is intended to be used as development/testing environment.


The default database created by the parent `postgres` image will have the following extensions installed:

* `postgis`
* `postgis_topology`


## Usage

In order to run a basic container capable of serving a PostGIS-enabled database, start a container as follows:

    docker run -d saxix/pypg
