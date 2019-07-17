#!/bin/bash

if [[ $DEBUG == true ]]; then
  set -ex
else
  set -e
fi

mv om-cli/om-linux* om-cli/om-linux

chmod +x om-cli/om-linux
CMD=./om-cli/om-linux

$CMD -e config/$OPSMAN_ENV_FILE_NAME delete-installation
