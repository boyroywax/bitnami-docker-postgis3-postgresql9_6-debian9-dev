# bitnami-docker-postgis3-postgresql9_6-debian9-dev

# CURRENT VERSION NOT WORKING

[PostGIS Installation Documentation](https://postgis.net/docs/postgis_installation.html#make_install_postgis_extensions)

Install Proj4 to debian. [Proj.org Documentation](https://proj.org/install.html)
```bash
sudo apt-get install proj-bin
```

Install GDAL binaries.  [GDAL Documentation](https://gdal.org/download.html)
```bash
wget https://github.com/OSGeo/gdal/releases/download/v3.0.2/gdal-3.0.2.tar.gz
tar xzvf gdal-3.0.2.tar.gz
cd gdal-3.0.2
./configure
make -j  $(nproc)
make install
```


Export Postgresql password to environment
```bash
export POSTGRES_PASSWORD=(kubectl get secret --namespace default postgis-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
```

Connect to container bash terminal
```bash
kubectl run postgis-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/boyroywax/bitnami-postgis-dev:latest --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- bash
```

Connect to container psql terminal
```bash
kubectl run postgis-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/boyroywax/bitnami-postgis-dev:latest --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgis-postgresql -U postgres -d postgres -p 5432
```


Add plv8 extension to postgresql - [github](https://plv8.github.io)
```postgresql
CREATE EXTENSION plv8;
```


Add PostGIS extension to postgresql - [PostGIS 3.0 Docs](http://postgis.net/docs/manual-3.0/postgis_installation.html#create_new_db_extensions)
```postgresql
CREATE EXTENSION postgis;
```

