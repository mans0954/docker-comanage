# docker-comanage
Unofficial Docker container for Internet2 COmanage

For official information about COmanage, please see:

http://www.internet2.edu/products-services/trust-identity/comanage/
https://spaces.internet2.edu/display/COmanage/Home

COmanage is distributed under the Apache 2.0 license and is Copyright 2012-16 University Corporation for Advanced Internet Development, Inc. It includes CakePHP which is distributed under the MIT License and Copyright 2005-2015, Cake Software Foundation, Inc.

The files in this project are distributed under the Apache 2.0 license and is Copyright 2016 Christopher Hoskin.

THIS CONTAINER IS PURELY FOR DEMONSTRATION PURPOSES ON YOUR LOCALHOST. IT IS NOT IN ANY WAY PRODUCTION READY. IT USES WEAK DEFAULT PASSWORDS.

The container requires a separate container to provide a Postgresql database. The name of the database, the role and the password are all 'comanage'.

This demo container is not yet set up to work with SAML. Basic Auth is used instead. An administrator account is created with username 'admin' and password 'tamesis' on first run.


# Use

## With docker-compose

```
docker-compose build
docker-compose up
docker-compose ls
docker-compose stop
```


## Manual

Start postgres:

docker run -d --name postgres-comanage -v comanage-data:/var/lib/postgresql/data -e POSTGRES_USER=comanage -e POSTGRES_PASSWORD=comanage -e POSTGRES_DB=comanage postgres

Check that the database is up:

docker logs postgres-comanage

Start comanage:

docker run -ti --link postgres-comanage:postgres --name comanage mans0954/comanage

If you are using nss docker (on Linux hosts) you should then be able to browse to:

http://comanage.docker/registry

Otherwise browse to http://172.17.0.3/registry (your IP address may be different)

Login, through basic auth, with username 'admin' and password 'tamesis'.

