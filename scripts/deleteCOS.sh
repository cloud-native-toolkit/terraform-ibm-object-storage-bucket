#!/bin/bash

REGION="$1"
BUCKET_NAME="$2"
KEY_ID="$3"

if [[ -z "${REGION}" ]] || [[ -z "$BUCKET_NAME" ]] || [[ -z "$KEY_ID" ]]; then
  echo "Usage: deleteCOS.sh REGION BUCKET_NAME KEY_ID"
  exit 0
fi

if ! ibmcloud account show 1> /dev/null 2> /dev/null; then
  echo "Not logged in"

  if [[ -z "${IBMCLOUD_API_KEY}" ]] || [[ -z "${RESOURCE_GROUP}" ]]; then
    echo "In order to log in, IBMCLOUD_API_KEY and RESOURCE_GROUP must be provided as environment variables"
    exit 1
  fi

  echo "Logging in to IBM Cloud account"
  ibmcloud login --apikey "${IBMCLOUD_API_KEY}" -g "${RESOURCE_GROUP}" -r "${REGION}"
else
  echo "Current IBM Cloud target"
  ibmcloud target
fi

JQ=$(command -v jq || command -v ./bin/jq)

if [[ -z "${JQ}" ]]; then
  echo "jq missing. Installing for linux-amd64 architecture..."
  mkdir -p ./bin && curl -Lo ./bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  JQ="${PWD}/bin/jq"
fi

CREDENTIAL=$(ibmcloud resource service-key "${KEY_ID}" --output JSON | "$JQ" -c '.[]')

ENDPOINT_URL=$(echo "${CREDENTIAL}" | "$JQ" -r '.credentials.endpoints // empty')
ACCESS_KEY=$(echo "${CREDENTIAL}" | "$JQ" -r '.credentials.cos_hmac_keys.access_key_id // empty')
SECRET_KEY=$(echo "${CREDENTIAL}" | "$JQ" -r '.credentials.cos_hmac_keys.secret_access_key // empty')

if [[ -z "$ENDPOINT_URL" ]] || [[ -z "$ACCESS_KEY" ]] || [[ -z "$SECRET_KEY" ]]; then
  echo "ACCESS_KEY or SECRET_KEY could not be determined from credential: ${KEY_ID}. Be sure to enable HMAC on the COS credentials"
  exit 0
fi

echo "Getting endpoints from $ENDPOINT_URL"
ENDPOINT_HOST=$(curl -sL "$ENDPOINT_URL" | "$JQ" --arg REGION "$REGION" -r '."service-endpoints".regional[$REGION]["public"][$REGION] // empty')
if [[ -z "${ENDPOINT_HOST}" ]]; then
  echo "Unable to find ENDPOINT_HOST"
  exit 1
fi

ENDPOINT="https://${ENDPOINT_HOST}"

echo "COS endpoint: ${ENDPOINT}"

MC=$(command -v mc || command -v ./bin/mc)
if [[ -z "${MC}" ]]; then
  echo "MinIO missing. Installing for linux-amd64 architecture..."
  mkdir -p ./bin && curl -Lo ./bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
  echo "MinIO has been installed"

  chmod +x ./bin/mc
  MC="$(cd ./bin || exit 1; pwd -P)/mc"
fi

${MC} config host add IBMCOS "${ENDPOINT}" "$ACCESS_KEY" "$SECRET_KEY" || exit 0
echo "MinIO configuration done for COS"

# delete contents
${MC} rm "IBMCOS/${BUCKET_NAME}/" --recursive --force || exit 0
echo "Deleted all bucket contents"
