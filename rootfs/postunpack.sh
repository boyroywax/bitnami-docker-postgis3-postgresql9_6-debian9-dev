#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libpostgresql.sh

# Load PostgreSQL environment variables
eval "$(postgresql_env)"

for dir in "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR"

# Redirect all logging to stdout
ln -sf /dev/stdout "$POSTGRESQL_LOG_DIR/postgresql.log"

# Install PostGIS tooling - first is GEOS
cd ~
wget http://download.osgeo.org/geos/geos-${GEOS_VER}.tar.bz2
tar xvf geos-${GEOS_VER}.tar.bz2
cd geos-${GEOS_VER}
./configure
make -j $(nproc)
make install
# Install postgis-2.5.2
cd ~
wget https://download.osgeo.org/postgis/source/postgis-${POST_GIS_VER}.tar.gz
tar xzvf postgis-${POST_GIS_VER}.tar.gz
cd postgis-${POST_GIS_VER}
./configure
make -j  $(nproc)
make install
# Install plv8
cd ~
wget https://github.com/plv8/plv8/archive/v${PLV8_VER}.tar.gz
tar -xvzf v${PLV8_VER}.tar.gz
cd plv8-${PLV8_VER}/
make -j  $(nproc) 
make install
ldconfig
# Clean up
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
rm -rf ~/geos-${GEOS_VER}.tar.bz2 ~/geos-${GEOS_VER} ~/postgis-${POST_GIS_VER}.tar.gz ~/postgis-${POST_GIS_VER} ~/v${PLV8_VER}.tar.gz ~/plv8-${PLV8_VER}
 
