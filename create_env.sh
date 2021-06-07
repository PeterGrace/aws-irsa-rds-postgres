#!/bin/bash
if [[ -z "$1" ]]
then
    echo "please specify path for env file writing"
    echo "example: $0 /irsa/env_file.env"
    exit 1
fi
export ENV_FILE=$1
set -u
aws sts assume-role-with-web-identity \
 --role-arn $AWS_ROLE_ARN \
 --role-session-name ${PGUSER}_irsa \
 --web-identity-token file://$AWS_WEB_IDENTITY_TOKEN_FILE \
 --duration-seconds 300 > /tmp/irp-cred.txt
export AWS_ACCESS_KEY_ID="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.AccessKeyId")"
export AWS_SECRET_ACCESS_KEY="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.SecretAccessKey")"
export AWS_SESSION_TOKEN="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.SessionToken")"
rm /tmp/irp-cred.txt
export PGPASSWORD=$(aws rds generate-db-auth-token --host $PGHOST --port $PGPORT --username $PGUSER)
#echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >> $ENV_FILE
#echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >> $ENV_FILE
#echo "export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}" >> $ENV_FILE
echo "export PGPASSWORD=\"${PGPASSWORD}\"" >> $ENV_FILE
