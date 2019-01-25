# File: url-redirect-setenv.ps1
# Purpose: set common variables

#DockerHub
Set-Variable -Name "CAP_DOCKERHUB_NAME" -Value "uwthalesians"

# Name of DockerHub repository name
Set-Variable -Name "CAP_URL_REDIRECT_REPO_NAME" -Value "url-redirect"

# URL-Redirect Specific
Set-Variable -Name CAP_URL_REDIRECT_CTNR_NAME -Value "cap_url_redirect"

Set-Variable -Name CAP_REDIRECT_TO_URL -Value "http://www.ph.perceptia.info/"

Set-Variable -Name CAP_DEPLOYMENT_SERVER_URL -Value "uw-thalesians.spirrochet.com"
Set-Variable -Name CAP_DEPLOYMENT_SERVER_USER -Value "root"

