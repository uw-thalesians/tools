#!/usr/bin/env bash
# Variables will be passed in over SSH

#DockerHub Organization Name
CAP_DOCKERHUB_NAME=$CAP_DOCKERHUB_NAME

# url-redirect specific
CAP_URL_REDIRECT_REPO_NAME=$CAP_URL_REDIRECT_REPO_NAME

CAP_URL_REDIRECT_CTNR_NAME=$CAP_URL_REDIRECT_CTNR_NAME

CAP_REDIRECT_TO_URL=$CAP_REDIRECT_TO_URL

#Ensures env vars were set, if not will stop execution
if [[ -z "$CAP_DOCKERHUB_NAME" ]]; then
    echo "Must provide CAP_DOCKERHUB_NAME in environment" 1>&2
    echo "Exiting with status code 1"
    exit 1
fi

if [[ -z "$CAP_URL_REDIRECT_CTNR_NAME" ]]; then
    echo "Must provide CAP_URL_REDIRECT_CTNR_NAME in environment" 1>&2
    echo "Exiting with status code 1"
    exit 1
fi
if [[ -z "$CAP_URL_REDIRECT_REPO_NAME" ]]; then
    echo "Must provide CAP_URL_REDIRECT_REPO_NAME in environment" 1>&2
    echo "Exiting with status code 1"
    exit 1
fi
if [[ -z "$CAP_REDIRECT_TO_URL" ]]; then
    echo "Must provide CAP_REDIRECT_TO_URL in environment" 1>&2
    echo "Exiting with status code 1"
    exit 1
fi

# Stop and remove the gateway container
docker rm --force $CAP_URL_REDIRECT_CTNR_NAME

docker pull $CAP_DOCKERHUB_NAME/$CAP_URL_REDIRECT_REPO_NAME

docker run \
--detach \
--env REDIRECT_TO_URL=$CAP_REDIRECT_TO_URL \
--name $CAP_URL_REDIRECT_CTNR_NAME \
--publish "80:80" \
--restart on-failure \
$CAP_DOCKERHUB_NAME/$CAP_URL_REDIRECT_REPO_NAME
