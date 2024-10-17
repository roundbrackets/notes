#!/bin/bash

echo "Building aws-postgres"

TOKEN=$(gum input --char-limit=10000 --placeholder "Upbound access token")
VERSION_TAG=$(gum input --placeholder "Package version tag" --value "v0.0.1")

up login -a r0undbrackets -t $TOKEN
up repo get aws-postgres
up xpkg build --name aws-postgres.xpkg
up xpkg push xpkg.upbound.io/r0undbrackets/aws-postgres:${VERSION_TAG} -f aws-postgres.xpkg
