#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update the package lists
apt-get update
echo "Package lists updated."
echo " "

# Install PostgreSQL
apt-get install -y postgresql postgresql-contrib
echo "PostgreSQL installed."
echo " "

# Start the PostgreSQL service
service postgresql start
echo "PostgreSQL service started."
echo " "

# Create a new user and database for Hive
sudo -u postgres psql <<EOF
CREATE DATABASE metastore_db;
CREATE USER hiveuser WITH ENCRYPTED PASSWORD 'hivepassword';
GRANT ALL PRIVILEGES ON DATABASE metastore_db TO hiveuser;
\q
EOF
echo "Hive user and database created."

# Create hive-site.xml with PostgreSQL configuration
HIVE_SITE_PATH="/usr/local/apache-hive-2.3.5-bin/conf/hive-site.xml"
cat <<EOL > "$HIVE_SITE_PATH"
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:postgresql://localhost/metastore_db</value>
    <description>JDBC connect string for a JDBC metastore</description>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.postgresql.Driver</value>
    <description>Driver class name for a JDBC metastore</description>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>hiveuser</value>
    <description>Username to use against metastore database</description>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>hivepassword</value>
    <description>Password to use against metastore database</description>
  </property>
</configuration>
EOL
echo "hive-site.xml created."
echo " "

# Initialize the Hive schema in PostgreSQL
schematool -initSchema -dbType postgres
echo "Hive schema initialized."
echo " "

echo "Hive metastore setup with PostgreSQL completed successfully."
echo "ME COOOOOOOOOOOOOOOORRRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOo"