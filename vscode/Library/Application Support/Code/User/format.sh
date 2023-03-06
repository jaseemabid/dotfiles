#!/bin/sh

jq --indent 4 --sort-keys . settings.json | sponge settings.json
