# docker-comanage
Unofficial Docker container for Internet2 COmanage

For official information about COmanage, please see:

http://www.internet2.edu/products-services/trust-identity/comanage/
https://spaces.internet2.edu/display/COmanage/Home

COmanage is distributed under the Apache 2.0 license and is Copyright 2012-16 University Corporation for Advanced Internet Development, Inc. It includes CakePHP which is distributed under the MIT License and Copyright 2005-2015, Cake Software Foundation, Inc.

The files in this project are distributed under the Apache 2.0 license and is Copyright 2016 Christopher Hoskin.

THIS CONTAINER IS PURELY FOR DEMONSTRATION PURPOSES ON YOUR LOCALHOST. IT IS NOT IN ANY WAY PRODUCTION READY. IT USES WEAK DEFAULT PASSWORDS.

The container requires a separate container to provide a Postgresql database. The name of the database, the role and the password are all 'comanage'.

# Components

The demo consists of the following containers:

* comanage: COmanage container (SAML entity id `http://comanage.docker/shibboleth`)
* comanage-postgres: PostgreSQL container, based on the official image https://hub.docker.com/_/postgres/
* bar-idp: Shibboleth IdP v3 container for the fictitious University of Barsetshire (SAML entity id `http://bar-idp.bar.ac.uk:8080/idp/shibboleth`)
* bar-kdc: MIT Kerberos v5 KDC container for the fictitious University of Barsetshire (Kerberos realm BAR.AC.UK)

The following networks:

* example: With nssdocker installed, all container hostnames will be accessible from the host as `<containername>.docker`

And the following volumes:

* dockercomanage_comanage-data: Allows the PostgeSQL database to persist between runs
* dockercomanage_metadata: Allows the generated IdP metadata to be shared with the COmanage container

The following accounts are generated:

* administrator account with username `admin@bar.ac.uk` and password `tamesis`
* user account with username `user1@bar.ac.uk` and password `password1`.

# Prerequisites

* docker-compose
* nssdocker

# Use

## With docker-compose

```
docker-compose build
docker-compose up
```

Go to http://comanage.docker/registry . When redirected to Shibboleth, authenticate as user `user1` with password `password1`.

Stop:

```
docker-compose stop
```
# Caveats

In order to complete this demo environment in the minimum time possible, a number of shortcuts have been taken, which make it totally unsuited to production. A non-exhaustive list is:

* Unsigned logout assertions accepted
* Not all downloads verified


