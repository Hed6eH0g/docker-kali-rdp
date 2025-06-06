# docker-kali-rdp

A simple kali rdp environment using docker.

### .env file
```
ROOT_PASSWD=root         # root user password in kali
NONROOT_USER=kali        # root user password in kali
NONROOT_PASSWD=kali      # root user password in kali
TIMEZONE=Europe/London   # timezone 


### Following are the configs for Bloodhound CE
# Select the image tag to use (latest, edge, or version number)
BLOODHOUND_TAG=latest

# Graph driver switch (use neo4j or pg)
GRAPH_DRIVER=neo4j

# Postgres auth configuration
POSTGRES_USER=bloodhound
POSTGRES_PASSWORD=bloodhoundcommunityedition
POSTGRES_DB=bloodhound
POSTGRES_DB_HOST=app-db

# Auth string for NEO4J credentials
NEO4J_USER=neo4j
NEO4J_SECRET=bloodhoundcommunityedition
NEO4J_HOST=graph-db:7687/

# Allow upgrades of neo4j data (useful when importing external data)
NEO4J_ALLOW_UPGRADE=true

# Data directory for neo4j
# Uncomment if you want a filesystem mount for your neo4j data in the current directory
#NEO4J_DATA_MOUNT=./neo4j/data

# Port forwards
BLOODHOUND_HOST=127.0.0.1
BLOODHOUND_PORT=8080
POSTGRES_PORT=5432
NEO4J_DB_PORT=7687
NEO4J_WEB_PORT=7474

# BloodHound Configuration Parameters

# Uncomment if you want to disable cypher complexity limit
#bhe_disable_cypher_complexity_limit=true

# Uncomment if you want to enable cypher mutations
#bhe_enable_cypher_mutations=true

# Uncomment if you want to set the cypher graph query memory limit (in GiB), 0 to remove limit
#bhe_graph_query_memory_limit=0

# Potentially sensitive configuration parameters
## SAML
#bhe_saml_sp_cert=
#bhe_saml_sp_key=

## TLS
#bhe_tls_cert_file=
#bhe_tls_key_file=

## Application Database
#bhe_database_connection=
#bhe_database_addr=
#bhe_database_username=
#bhe_database_secret=
#bhe_database_database=

## Neo4J
#bhe_neo4j_connection=
#bhe_neo4j_addr=
#bhe_neo4j_username=
#bhe_neo4j_secret=
#bhe_neo4j_database=

## Crypto
#bhe_crypto_jwt_signing_key=

## Default Admin
#bhe_default_admin_principal_name=
#bhe_default_admin_password=
#bhe_default_admin_email_address=
#bhe_default_admin_first_name=
#bhe_default_admin_last_name=
```

### build 
```
$ docker compose up --build -d
```

### acknowledgement
- [Kali Linux](https://www.kali.org/docs/containers/official-kalilinux-docker-images/)
- [Bloodhound](https://github.com/SpecterOps/BloodHound)
