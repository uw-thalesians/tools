# File: url-redirect-build.ps1
# Purpose: automate building Docker Container with go program.

# Ensure that the Variable CAP_DOCKERHUB_NAME is set.
# Exit failure if variable is not set.
if (-Not (Test-Path variable:CAP_DOCKERHUB_NAME))
{
    Write-Output "You need to set the variable CAP_DOCKERHUB_NAME"
    Exit 1
}

# Ensure that the Variable CAP_URL_REDIRECT_REPO_NAME is set
# Exit failure if variable is not set.
if (-Not (Test-Path variable:CAP_URL_REDIRECT_REPO_NAME))
{
    Write-Output "You need to set the variable CAP_URL_REDIRECT_REPO_NAME"
    Exit 1
}

# Remove image if already present.
docker image rm $CAP_DOCKERHUB_NAME/$CAP_URL_REDIRECT_REPO_NAME

# Build go program for linux
Write-Output "Building go program for linux..."

# Set environment varialbes to build go program for a linux machine.
$Env:GOOS="linux"
$Env:GOARCH="amd64"
go build -o url-redirect

# Build the docker image using the Dockerfile in this directory
Write-Output "Building docker image..."

docker build --tag=$CAP_DOCKERHUB_NAME/$CAP_URL_REDIRECT_REPO_NAME .

# Remove the linux go program file
Write-Output "Cleaning up go program file"

go clean

