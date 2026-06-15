#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

echo "Reading Terraform outputs..."
CONN_STRING=$(cd "$ROOT_DIR" && terraform output -raw connection_string)
PASSWORD=$(cd "$ROOT_DIR" && terraform output -raw db_credential_password)
USERNAME="simple-retail"
BUCKET="supermarket"

echo "Importing data into: $CONN_STRING"

# AA-Store Data
cbimport json --format list \
  --cluster "couchbases://$CONN_STRING" \
  --username "$USERNAME" \
  --password "$PASSWORD" \
  --bucket "$BUCKET" \
  --scope-collection-exp "AA-Store.inventory" \
  --dataset "file://$SCRIPT_DIR/aa_store_inventory.json" \
  --generate-key "%id%"

cbimport json --format list \
  --cluster "couchbases://$CONN_STRING" \
  --username "$USERNAME" \
  --password "$PASSWORD" \
  --bucket "$BUCKET" \
  --scope-collection-exp "AA-Store.profile" \
  --dataset "file://$SCRIPT_DIR/aa-store-01-profile.json" \
  --generate-key "%id%"

# NYC-Store Data
cbimport json --format list \
  --cluster "couchbases://$CONN_STRING" \
  --username "$USERNAME" \
  --password "$PASSWORD" \
  --bucket "$BUCKET" \
  --scope-collection-exp "NYC-Store.inventory" \
  --dataset "file://$SCRIPT_DIR/nyc_store_inventory.json" \
  --generate-key "%id%"

cbimport json --format list \
  --cluster "couchbases://$CONN_STRING" \
  --username "$USERNAME" \
  --password "$PASSWORD" \
  --bucket "$BUCKET" \
  --scope-collection-exp "NYC-Store.profile" \
  --dataset "file://$SCRIPT_DIR/nyc-store-01-profile.json" \
  --generate-key "%id%"
