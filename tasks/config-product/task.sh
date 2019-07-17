#!/bin/bash

if [[ $DEBUG == true ]]; then
  set -ex
else
  set -e
fi

mv om-cli/om-linux* om-cli/om-linux

chmod +x om-cli/om-linux
OM_CMD=./om-cli/om-linux

$OM_CMD -e env/${OPSMAN_ENV_FILE_NAME} configure-product --config config/$CONFIG_FILE_NAME
