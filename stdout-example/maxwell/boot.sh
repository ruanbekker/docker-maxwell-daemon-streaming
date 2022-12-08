#!/usr/bin/env bash

bin/maxwell \
  --user=$MYSQL_USERNAME \
  --password=$MYSQL_PASSWORD \
  --host=$MYSQL_HOST \
  --output_primary_keys=$MAXWELL_OUTPUT_PRIMARY_KEYS \
  --producer=stdout
