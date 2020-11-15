#!/usr/bin/env bash
cd tools/nodejs

export TAG=''
# for master do prereleases
if [[ "$GITHUB_REF" =~ ^refs/tags/v.+$ ]] ; then
	# proper release
	npm version `echo $GITHUB_REF | sed 's|refs/tags/v||'`
else 
	git describe --tags --long  

	export VER=`git describe --tags --abbrev=0 | tr -d "v"`
	export DIST=`git describe --tags --long | cut -f2 -d-`

	# set version to lastver
	npm version $VER
	npm version prerelease --preid="dev"$DIST
	export TAG='--tag next'
fi

# upload to npm, maybe
if [[ "$GITHUB_REF" =~ ^(refs/heads/master|refs/tags/v.+)$ && "$1" = "upload" ]] ; then
	npm publish $TAG
fi