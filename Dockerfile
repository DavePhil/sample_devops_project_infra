FROM hashicorp/terraform:latest

# Installer bash, curl et d'autres utilitaires essentiels
RUN apk add --no-cache bash curl git
