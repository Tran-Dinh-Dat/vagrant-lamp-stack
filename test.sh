#!/bin/bash

# Check if the .env file exists
if [ ! -f .env ]; then
    echo ".env file not found!"
    exit 1
fi

# Load the .env file
set -a
source .env
set +a

echo $APP_NAME

