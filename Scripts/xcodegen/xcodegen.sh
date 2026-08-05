#!/bin/sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="$(dirname "$SCRIPTS_DIR")"

if ! command -v xcodegen >/dev/null 2>&1; then
    echo "warning: XcodeGen not installed, download it from https://github.com/yonaskolb/XcodeGen"
    exit 1
fi

if [ ! -f "$SCRIPTS_DIR/project.env" ]; then
    echo "Missing Scripts/project.env. Copy Scripts/project.env.example to Scripts/project.env and fill local values."
    exit 1
fi

set -a
. "$SCRIPTS_DIR/project.env"
set +a

xcodegen --spec "$SCRIPT_DIR/project.yml" --project "$PROJECT_DIR"
