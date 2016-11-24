# dkr-certbot

Alpine certbot

Based on:
  1. https://hub.docker.com/r/ecor/letsencrypt/~/dockerfile/
  2. https://github.com/certbot/certbot/blob/master/Dockerfile

## Updating certbot

Edit the `Dockerfile` and update BUILD_DATE. This will force
a new git pull for the latest version of certbot

```
make
make push-all
```
