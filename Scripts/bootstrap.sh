#!/bin/sh

set -e

cd "$(dirname "$0")"

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required. Install it from https://brew.sh and run this script again."
    exit 1
fi

if [ -f ../Brewfile ]; then
    echo "Install command line tools from Brewfile"
    brew bundle --file=../Brewfile
fi

if command -v bundle >/dev/null 2>&1; then
    echo "Install Ruby dependencies"
    (cd .. && bundle install)
else
    echo "warning: Bundler is not installed. Skipping Ruby dependencies."
fi

if [ ! -f project.env ]; then
    echo "Missing Scripts/project.env. Copy Scripts/project.env.example to Scripts/project.env and fill local values."
    exit 1
fi

set -a
. ./project.env
set +a

printf "Have you configured Scripts/project.env? [y/N] "
read answer
case "$answer" in
    [yY]|[yY][eE][sS])
        ;;
    *)
        echo "Please fill Scripts/project.env and run this script again."
        exit 1
        ;;
esac

./generate.sh

echo "All set up. Opening ${PROJECT_NAME}.xcodeproj in Xcode."
open "../${PROJECT_NAME}.xcodeproj"
