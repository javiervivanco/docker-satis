# Tiny Satis 

This satis command build a dist directory with packages that you defined each time when it runs on docker.

If you want to serve this files you can used nginx 

## Volumes

### SSH    
If you need connect to private repo. You can mount your ssh config like id_ id_rsa, id_rsa.pub, known_hosts  

    /root/.ssh

### Web

All packages that download go to this directory */data/satis/web*. If you want served files can do it with nginx see bellow

    /data/satis/web


### Cron 

If you can run periodically satis. You can run docker container in your docker host. For example

    docker run --name mysatis ...
    # in your cron
    docker start mysatis && docker logs -f mysatis  2>&1 > mylogs.log

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