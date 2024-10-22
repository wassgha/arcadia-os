#!/bin/sh

VERSION_FILE="VERSION"
CURRENT_VERSION=$(cat $VERSION_FILE)

IFS='.' read -r MAJOR MINOR PATCH <<EOF
$CURRENT_VERSION
EOF

if [ "$1" = "major" ]; then
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
elif [ "$1" = "minor" ]; then
    MINOR=$((MINOR + 1))
    PATCH=0
else
    PATCH=$((PATCH + 1))
fi

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo $NEW_VERSION > $VERSION_FILE
echo "Updated version to $NEW_VERSION"
