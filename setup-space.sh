#!/bin/bash

HELP="
Using:
    $ sh setup-space.sh [APP-ID]

You can write \"--help\" or \"-h\" to show this message.
"

if [ $# -eq 0 ]; then
    echo "Nothing to do. You can write \"--help\" or \"-h\" to show help message."
    exit 1
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$HELP"
    exit 0
fi

APP_ID="$1"
RESOURCES_PATH="/$(echo $APP_ID | sed 's/\./\//g')/"
RESOURCES_PATH_ESCAPED="$(echo $RESOURCES_PATH | sed 's/\//\\\//g')"

IFS="." read -r -a elems <<< "$APP_ID"

APP_NAMESPACE="${elems[-1]}"
APP_NAME=$(echo "$APP_NAMESPACE" | sed 's/\([a-z]\)\([A-Z]\)/\1 \2/g')
APP_COMMAND="$(echo "$APP_NAMESPACE" | sed 's/\(.\)\([A-Z]\)/\1-\2/g' | tr '[:upper:]' '[:lower:]')"
APP_COMMAND_C_NAME="$(echo $APP_COMMAND | sed 's/-/_/g')"
DEVELOPER_NAME="${elems[-2]}"

find ./ -type f -exec sed -i "s/<<APP-ID>>/$APP_ID/g" {} +
find ./ -type f -exec sed -i "s/<<RESOURCES-PATH>>/$RESOURCES_PATH_ESCAPED/g" {} +
find ./ -type f -exec sed -i "s/<<APP-NAME>>/$APP_NAME/g" {} +
find ./ -type f -exec sed -i "s/<<APP-COMMAND>>/$APP_COMMAND/g" {} +
find ./ -type f -exec sed -i "s/<<APP-COMMAND-C-NAME>>/$APP_COMMAND_C_NAME/g" {} +
find ./ -type f -exec sed -i "s/<<DEVELOPER-NAME>>/$DEVELOPER_NAME/g" {} +
find ./ -type f -exec sed -i "s/<<APP-NAMESPACE>>/$APP_NAMESPACE/g" {} +

find . -depth -name '*<<APP-ID>>*' -exec bash -c 'mv "$1" "${1//<<APP-ID>>/$2}"' _ {} "$APP_ID" \;

rm ./setup-space.sh
