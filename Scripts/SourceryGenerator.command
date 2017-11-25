#!/bin/sh

### Make sure Sourcery is installed, if not ‘brew install sourcery’ ###

cd "$(dirname "$0")"
cd ..
sourcery --config .sourcery.yml