#!/bin/bash

if [ -z "${NPM_EMAIL}" ]; then
  error 'Please specify email'
  exit 1
fi

if [ -z "${NPM_AUTH_TOKEN}" ]; then
  error 'Please specify auth token'
  exit 1
fi

if [ ! -f ./package.json ]; then
  error 'Project must contain a package.json'
  exit 1
fi

if [ -n "${$WERCKER_CACHE_DIR}" ]; then
  npm config set cache "$WERCKER_CACHE_DIR/wercker/npm"
fi

if [ -z "${NPM_ACCESS}" ]; then
  NPM_ACCESS=''
else
  NPM_ACCESS="--access=${NPM_ACCESS}"
fi

echo _auth = "${NPM_AUTH_TOKEN}" > ~/.npmrc
echo email = "${NPM_EMAIL}" >> ~/.npmrc

NPM_VERSION=$(grep package.json -e 'version' | awk '{print substr($2, 2, length($2)-3)}')
NPM_VERSION_PRERELEASE=$(echo "${NPM_VERSION}" | cut -d '-' -f 2 -s)

echo NPM_VERSION="${NPM_VERSION}"
echo NPM_VERSION_PRERELEASE="${NPM_VERSION_PRERELEASE}"

if [ -n "${NPM_VERSION_TAG}" ]; then
  echo "npm publish --tag ${NPM_VERSION_TAG} ${NPM_ACCESS}"
  npm publish --tag "${NPM_TAG}" "${NPM_ACCESS}"

elif [ -n "${NPM_VERSION_PRERELEASE}" ]; then
  echo "npm publish --tag ${WERCKER_GIT_BRANCH} ${NPM_ACCESS}"
  npm publish --tag "${WERCKER_GIT_BRANCH}" "${NPM_ACCESS}"

else
  echo "npm publish ${NPM_ACCESS}"
  npm publish "${NPM_ACCESS}"

fi
