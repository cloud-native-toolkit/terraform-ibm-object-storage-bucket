#!/bin/bash

BUCKET_NAME="$1"
KEY_ID="$2"

if [[ -z "$BUCKET_NAME" ]] || [[ -z "$KEY_ID" ]]; then
  echo "Usage: deleteCOS.sh BUCKET_NAME KEY_ID"
  exit 0
fi

if ! ibmcloud account show 1> /dev/null 2> /dev/null; then
  ibmcloud login --apikey "${IBMCLOUD_API_KEY}" -g "${RESOURCE_GROUP}" -r "${REGION}"
else
  ibmcloud target
fi

JQ=$(command -v jq || command -v ./bin/jq)

if [[ -z "${JQ}" ]]; then
  echo "jq missing. Installing"
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
ENDPOINT_HOST=$(curl -sL "$ENDPOINT_URL" | "$JQ" --arg REGION "$REGION" -r '."service-endpoints".regional[$REGION]["public"][$REGION]')
ENDPOINT="https://${ENDPOINT_HOST}"

VAR1=$(command -v ./mc)
if [[ -z "$VAR1" ]]; then
  echo "Installing MinIO"
  wget https://dl.min.io/client/mc/release/linux-amd64/mc
  echo "MinIO has been installed"
fi

chmod +x mc
echo "mc has permissions"

./mc config host add IBMCOS "${ENDPOINT}" "$ACCESS_KEY" "$SECRET_KEY" || exit 0
echo "Mc configration done"

# delete contents
./mc rm "IBMCOS/${BUCKET_NAME}/" --recursive --force || exit 0
echo "deleted all bucket contents" 
