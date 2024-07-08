#!/usr/bin/env bash

# Must be launched from frontend's root foler

user_build_type_input="$1"
user_compose_command_input="$2"

# Set build types and get user desired
# shellcheck source-path=SCRIPTDIR/../
. ./.docker/.scripts/get-build-type.sh
build_type=$(get_build_type "${user_build_type_input}")

compose_args=()
if [ "${build_type}" == "${build_dev_type}" ]; then
  compose_args+=( "-f ./.docker/compose.override.yml" )
fi

# Set compose commands and get user desired
# shellcheck source-path=SCRIPTDIR/../
. ./.docker/.scripts/get-compose-command.sh
compose_command=$(get_compose_command "${user_compose_command_input}")

compose_command_args=()
if [ "${compose_command}" == "${compose_up_command}" ]; then
  compose_command_args+=( "--build" )
  compose_command_args+=( "--wait" )
fi

if [ "${compose_command}" == "${compose_watch_command}" ]; then
  compose_command_args+=( "--no-up" )
fi

if [ "${compose_command}" == "${compose_up_command}" ]; then
  compose_command_args+=( "--force-recreate" )
fi

if [ "${compose_command}" == "${compose_watch_command}" ] || [ "${compose_command}" == "${compose_config_command}" ]; then
  if [ "${build_type}" == "${build_dev_type}" ] || [ "${build_type}" == "${build_staging_type}" ]; then
    compose_args+=( "-f ./.docker/compose.watch.yml" )
  fi
fi

final_command=$"docker compose \
  --env-file ./.docker/.${build_type}.env \
  \
  -f ./.docker/compose.yml \
  \
  ${compose_args[@]} \
  \
  ${compose_command} \
  \
  ${compose_command_args[@]}"

echo ""
echo "🤖, let me past!"
echo ""
echo "Launching this command just for you:"
echo "${final_command}"
echo ""

${final_command}
