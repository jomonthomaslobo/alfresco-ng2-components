#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/../../../

rm -rf tmp && mkdir tmp;


if [[ $TRAVIS_PULL_REQUEST == "false" ]];
then

    if [[ $TRAVIS_BRANCH == "development" ]];
    then
         #TODO remove when we are going to use the new about
        ./scripts/update-version.sh -gnu -nextalpha || exit 1;
    fi

    node ./scripts/pre-publish.js

    npm install

    ./scripts/npm-build-all.sh || exit 1;
else
    npm install @alfresco/adf-cli@alpha
    ./node_modules/@alfresco/adf-cli/bin/adf-cli update-version --alpha --pathPackage "$(pwd)"

    npm install;
    ./scripts/smart-build.sh -b $TRAVIS_BRANCH  -gnu || exit 1;
fi;

echo "====== Build Demo shell dist ====="
npm run build:dist || exit 1;
