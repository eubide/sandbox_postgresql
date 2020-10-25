#!/bin/bash

yum install wget bison flex -y

mkdir -p /src/postgresql
cd /src/postgresql

# LABEL="9.2.4"
LABEL="12.4"

PSQL_DIR="/opt/postgres/${LABEL}"
PSQL_DAT="/usr/local/pgsql/data/${LABEL}"

wget https://ftp.postgresql.org/pub/source/v${LABEL}/postgresql-${LABEL}.tar.gz

tar xvfz postgresql-${LABEL}.tar.gz

mkdir -p /opt/postgres/${LABEL}

yum install -y bison flex readline-devel openssl-devel
yum install -y perl-ExtUtils-MakeMaker perl-ExtUtils-Embed

cd postgresql-${LABEL}

./configure --with-perl --enable-integer-datetimes --with-openssl --prefix=${PSQL_DIR}

make
make install 
cd contrib
make 
make install

export PATH="${PATH}:${PSQL_DIR}/bin"

adduser postgres

mkdir -p ${PSQL_DAT}
chown postgres ${PSQL_DAT}

su -c "initdb -D ${PSQL_DAT} -E UNICODE --locale=C" postgres 
su -c "pg_ctl -D ${PSQL_DAT} -l /home/postgres/logfile_${LABEL}.log start" postgres
