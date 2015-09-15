# Tiny Satis 

This satis only build one time when you run on docker.

The feature is that only build and download packages dist in a directory


## Volumes

### SSH    
If you need connect to private repo. You can mount your ssh config like id_ id_rsa, id_rsa.pub, known_hosts  

    /root/.ssh

### Web

All packages that download go to this directory */data/satis/web*. If you want served files can do it with nginx see bellow

    /data/satis/web

### satis.json

Mount your satis.json in this directory

    /data/satis/config

## Environment

    GITHUB_OAUTH: your github oauth
    VERBOSITY: verbosity level {v|vv|vvv}


# Example docker-compose.yml 

    voldata:
      image: tianon/true:latest
      command: /true
      volumes:
          - satis/web:/data/satis/web
          - satis/config:/data/satis/config
          - satis/certs:/root/.ssh
    satis:
        image: javiervivanco/docker-satis
        environment:
           GITHUB_OAUTH: XXXXXXXXXXXXXX
           VERBOSITY: vv
        volumes_from:
            - voldata
    web:
        image: nginx
        ports:
        - '80:80'
        volumes:
            - satis/web:/usr/share/nginx/html

# Example satis.json

    {
        "name": "Composer Mirror",
        "require": {
            "phpunit/phpunit": "*",
        },
        "repositories": [
            {
                "url": "https://packagist.org",
                "type": "composer"
            }
        ],
        "require-dependencies": true,
        "homepage": "http://localhost",
        "archive": {
            "directory": "dist",
            "format": "zip"
        }
    }