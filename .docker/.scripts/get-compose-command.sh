#!/usr/bin/env bash

# shellcheck source-path=SCRIPTDIR/../../
. ./.docker/.scripts/.has-element.sh

compose_config_command="config"
compose_up_command="up"
compose_watch_command="watch"

compose_command_allowed=(
  "${compose_up_command}" \
  "${compose_config_command}" \
  "${compose_watch_command}"
)

get_compose_command() {
  compose_command=$1

  if ! has_element "${compose_command}" "${compose_command_allowed[@]}" ; then
    echo "${compose_up_command}"
  fi

  echo "${compose_command}"
}
