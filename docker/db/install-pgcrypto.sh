#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  -- Create a new schema in this database named "extensions" (or whatever you want to name it)
  CREATE SCHEMA IF NOT EXISTS extensions;
  -- Enable this extension in this new schema
  CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;
  -- Update your database's "search_path" to also search the new "extensions" schema.
  -- You are just appending it on the end of the existing comma-separated list.
  ALTER DATABASE dspace SET search_path TO "\$user",public,extensions;
  -- Grant rights to call functions in the extensions schema to your dspace user
  GRANT USAGE ON SCHEMA extensions TO $POSTGRES_USER;
EOSQL