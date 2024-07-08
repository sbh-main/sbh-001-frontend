#!/usr/bin/env bash

# shellcheck source-path=SCRIPTDIR/../../
. ./.docker/.scripts/.has-element.sh

build_dev_type="dev"
build_prod_type="prod"
build_staging_type="staging"

build_type_allowed=(
  "${build_dev_type}" \
  "${build_prod_type}" \
  "${build_staging_type}"
)

get_build_type() {
  build_type=$1

  if ! has_element "${build_type}" "${build_type_allowed[@]}" ; then
    echo "${build_dev_type}"
  fi

  echo "${build_type}"
}

