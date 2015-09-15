#!/bin/sh
#/root/.composer/auth.json
#ssh-keygen -R
#ssh-keygen -f "/root/.ssh/known_hosts" -R HOSTNAME

if [ -z $VERBOSITY ]; then
    $VERBOSITY=v
fi

if [ ! -z $GITHUB_OAUTH ]; then
    composer config -g --unset github-oauth.api.github.com
    composer config -g github-oauth.github.com $GITHUB_OAUTH
fi

php ${SATIS_BIN} build ${SATIS_CONFIG} ${SATIS_PUBLIC}  -$VERBOSITY
