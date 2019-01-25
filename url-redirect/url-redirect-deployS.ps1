# Source variables
. .\url-redirect-setenv.ps1

# Ensure that the Variable CAP_DOCKERHUB_NAME is set
if (-Not (Test-Path variable:CAP_DOCKERHUB_NAME))
{
    Write-Output "You need to set the variable CAP_DOCKERHUB_NAME"
    Exit 1
}

# Ensure that the Variable CAP_URL_REDIRECT_REPO_NAME is set
if (-Not (Test-Path variable:CAP_URL_REDIRECT_REPO_NAME))
{
    Write-Output "You need to set the variable CAP_URL_REDIRECT_REPO_NAME"
    Exit 1
}

# Ensure that the Variable CAP_URL_REDIRECT_CTNR_NAME is set
if (-Not (Test-Path variable:CAP_URL_REDIRECT_CTNR_NAME))
{
    Write-Output "You need to set the variable CAP_URL_REDIRECT_CTNR_NAME"
    Exit 1
}

# Ensure that the Variable CAP_DEPLOYMENT_SERVER_URL is set
if (-Not (Test-Path variable:CAP_DEPLOYMENT_SERVER_URL))
{
    Write-Output "You need to set the variable CAP_DEPLOYMENT_SERVER_URL"
    Exit 1
}

# Ensure that the Variable CAP_DEPLOYMENT_SERVER_USER is set
if (-Not (Test-Path variable:CAP_DEPLOYMENT_SERVER_USER))
{
    Write-Output "You need to set the variable CAP_DEPLOYMENT_SERVER_USER"
    Exit 1
}

# Ensure that the Variable CAP_REDIRECT_TO_URL is set
if (-Not (Test-Path variable:CAP_REDIRECT_TO_URL))
{
    Write-Output "You need to set the variable CAP_REDIRECT_TO_URL"
    Exit 1
}

.\url-redirect-build.ps1

# Push the image to dockerhub
Write-Output "Pushing image to dockerhub..."

docker push $CAP_DOCKERHUB_NAME/$CAP_URL_REDIRECT_REPO_NAME

#Remove unused images
Write-Output "Cleaning up docker images..."

docker image prune --force

# Setup API Server
# Copy upgrade script to server
scp "$(Get-Location)/server-upgrade.sh" "$($CAP_DEPLOYMENT_SERVER_USER)@$($CAP_DEPLOYMENT_SERVER_URL):/$($CAP_DEPLOYMENT_SERVER_USER)"

ssh "$($CAP_DEPLOYMENT_SERVER_USER)@$($CAP_DEPLOYMENT_SERVER_URL)" `
"export CAP_DOCKERHUB_NAME=$($CAP_DOCKERHUB_NAME); export CAP_URL_REDIRECT_CTNR_NAME=$($CAP_URL_REDIRECT_CTNR_NAME); " `
"export CAP_URL_REDIRECT_REPO_NAME=$($CAP_URL_REDIRECT_REPO_NAME); export CAP_REDIRECT_TO_URL=$($CAP_REDIRECT_TO_URL); " `
"export ; chmod +x server-upgrade.sh; ./server-upgrade.sh"