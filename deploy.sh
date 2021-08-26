#!/bin/bash

Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Color_Off="\033[0m"       # Text Reset

echo -e "$Green Deploying updates to GitHub...$Color_Off"

if [ "$1" ]
  then msg="$1"
else
  msg="rebuilding site `date`"
fi

if [ "$2" ]
  then version="$2"
else
  read -p "$(echo -e $Red"Enter Tag Version: "$Color_Off)" version
fi

# Empty the public folder.
rm -rf public/*

# Change the version file
rm version.txt
rm buildDate.txt
echo "$version" >> version.txt
echo "`date +'%a, %Y-%m-%d %T'`" >> buildDate.txt

# Build the project.
hugo

# Add changes to git.
git add --all

# Commit changes.
git commit -am "$msg"

# Add a git tag, to show on the main repository that the site is live.
git tag v$version

# Push source and build repos.
git push origin master --tags
git subtree push --prefix=public git@github.com:sapianco/slack-matrix-migration-public.git gh-pages
