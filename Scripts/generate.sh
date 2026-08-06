#!/bin/sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if [ ! -f "$SCRIPT_DIR/project.env" ]; then
    echo "Missing Scripts/project.env. Copy Scripts/project.env.example to Scripts/project.env and fill local values."
    exit 1
fi

set -a
. "$SCRIPT_DIR/project.env"
set +a

echo "Prepare project directory"
if [ "$PROJECT_NAME" != "AppName" ] && [ -d "$PROJECT_DIR/AppName" ]; then
    mv "$PROJECT_DIR/AppName" "$PROJECT_DIR/$PROJECT_NAME"
fi

echo "Prepare Generated directory"
mkdir -p "$PROJECT_DIR/$PROJECT_NAME/Resources/Generated"

echo "Run xcodegen"
"$SCRIPT_DIR/xcodegen/xcodegen.sh"
