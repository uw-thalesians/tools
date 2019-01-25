. .\url-redirect-setenv.ps1

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

# Gateway Specific
Set-Variable -Name CAP_url_redirect_CTNR_NAME -Value "CAP_url_redirect"



.\url-redirect-build.ps1

# Push the image to dockerhub
Write-Output "Pushing image to dockerhub"

docker push $CAP_DOCKERHUB_NAME/$CAP_url_redirect_REPO_NAME

#Remove unused images
Write-Output "Cleaning up images"

docker image prune --force

# Setup API Server
scp "$(Get-Location)/server-upgrade.sh" root@uw-thalesians.spirrochet.com:/root

ssh root@uw-thalesians.spirrochet.com `
"export CAP_DOCKERHUB_NAME=$($CAP_DOCKERHUB_NAME); export CAP_url_redirect_CTNR_NAME=$($CAP_url_redirect_CTNR_NAME); " `
"export CAP_url_redirect_REPO_NAME=$($CAP_url_redirect_REPO_NAME); chmod +x server-upgrade.sh; ./server-upgrade.sh"