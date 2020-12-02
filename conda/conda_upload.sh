#!/usr/bin/env bash

## adapted on https://gist.github.com/zshaheen/fe76d1507839ed6fbfbccef6b9c13ed9
## Show command and exit immediately if a command exits with a non-zero status.
set -ex

## Settings (we build essentially a noarch package
PKG_NAME=nmrglue
ANACONDA_USER=spectrocat
OS=noarch

## TAG
TAG=$(git describe --tags)
echo "Current version string = $TAG"

## Extract components
IFS=$"-"
read -ra arr <<< "$TAG"

## latest version string
LATEST="${arr[0]}"
IFS=$"."
read -ra tag <<< "$LATEST";
NEXT_TAG="${tag[0]}.${tag[1]}.`expr ${tag[2]} + 1`"

if [[ $LATEST != $TAG ]]; then
  DEVSTRING="dev"
  VERSION=$NEXT_TAG
  PKG_NAME_VERSION="$PKG_NAME-$VERSION-$DEVSTRING.tar.bz2"
else
  DEVSTRING="stable"
  VERSION=$LATEST
  PKG_NAME_VERSION="$PKG_NAME-$VERSION-$DEVSTRING.tar.bz2"
fi

export VERSION=$VERSION
export DEVSTRING=$DEVSTRING

## Avoid uploading automatically
conda config --set anaconda_upload no

## set build folder
export CONDA_BLD_PATH="$HOME/conda-bld"
mkdir -p "$CONDA_BLD_PATH"

## configure conda
conda config -q --set always_yes yes --set changeps1 no
conda update -q -n base conda
conda config -q --add channels conda-forge
conda config -q --add channels "$ANACONDA_USER"
conda config -q --set channel_priority flexible

PKG_FILE="$CONDA_BLD_PATH/$OS/$PKG_NAME_VERSION"
echo "---> Building $PKG_FILE"
conda build conda

echo "---> Uploading $PKG_FILE"

## Here we will choose depending on the way this script is run
if [[ $USER != "travis" ]]; then
  ## if we are in local
  TRAVIS_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ $TRAVIS_BRANCH == $LAST_TAG ]]; then
    TRAVIS_TAG=$LAST_TAG
  fi
  ## else this run by TravisCI (this are env variables)
fi

if [[ "$TRAVIS_BRANCH" == "$TRAVIS_TAG" ]]; then
  ## This is a "main" release
  if [[ "$DEVSTRING" == "stable" ]]; then
    anaconda -t "$CONDA_UPLOAD_TOKEN" upload --force -u "$ANACONDA_USER" "$PKG_FILE";
  fi;
fi
