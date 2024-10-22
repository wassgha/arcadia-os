#!/bin/sh

VERSION_FILE="VERSION"
CURRENT_VERSION=$(cat $VERSION_FILE)

IFS='.' read -r MAJOR MINOR PATCH BUILD <<EOF
$CURRENT_VERSION
EOF

if [ "$1" = "major" ]; then
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    BUILD=0
elif [ "$1" = "minor" ]; then
    MINOR=$((MINOR + 1))
    PATCH=0
    BUILD=0
elif [ "$1" = "patch" ]; then
    PATCH=$((PATCH + 1))
    BUILD=0
else
    BUILD=$((BUILD + 1))
fi

NEW_VERSION="$MAJOR.$MINOR.$PATCH.$BUILD"
echo $NEW_VERSION > $VERSION_FILE
echo "Updated version to $NEW_VERSION"
