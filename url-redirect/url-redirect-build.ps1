# Ensure that the Variable CAP_DOCKERHUB_NAME is set
if (-Not (Test-Path variable:CAP_DOCKERHUB_NAME))
{
    Write-Output "You need to set the variable CAP_DOCKERHUB_NAME"
    Exit 1
}

# Ensure that the Variable CAP_url_redirect_REPO_NAME is set
if (-Not (Test-Path variable:CAP_url_redirect_REPO_NAME))
{
    Write-Output "You need to set the variable CAP_url_redirect_REPO_NAME"
    Exit 1
}

docker image rm $CAP_DOCKERHUB_NAME/$CAP_url_redirect_REPO_NAME

# Build go program for linux
Write-Output "Building go program for linux..."

$Env:GOOS="linux"
$Env:GOARCH="amd64"
go build -o url-redirect

# Build the docker image using the Dockerfile in this directory
Write-Output "Building docker image..."

docker build --tag=$CAP_DOCKERHUB_NAME/$CAP_url_redirect_REPO_NAME .

# Remove the linux go program file
Write-Output "Cleaning up go program file"

go clean

