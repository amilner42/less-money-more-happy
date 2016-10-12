#!/usr/bin/env bash

# Runs the application with `forever`, so that it restarts if it crashes. Meant
# to be used for production.

echo "========================================================"
echo "STARTING TASK: CD into top directory"
echo "========================================================"
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../;
echo "========================================================"
echo "COMPLETE TASK"
echo "========================================================"

. ./bin/helper-scripts/set-node-module-paths.sh;
. ./bin/build.sh;


# Runs the app `forever`.
"$BACKEND_NODE_MODULES_BIN"/forever start backend/lib/src/main.js;
