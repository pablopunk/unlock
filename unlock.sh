#!/bin/bash

dir=`realpath ${1:-.}`

if [ ! -d "$dir" ]
then
  echo "'$1' is not a directory"
  exit 1
fi

function is_git {
  [ -d ".git" ]
}

function is_git_clean {
  [ -z "`git status --porcelain`" ]
}

function qgit {
  git "$@" </dev/null >/dev/null 2>/dev/null
}

for current in `ls -d1 $dir/*`
do
  cd $current

  if [ is_git ] && [ ! is_git_clean ]
  then
    echo "Skipping $current. Git status not clean."
    continue
  fi

  if [ -f ".npmrc" ] && [ -z `grep "package-lock=false" < .npmrc` ]
  then
    echo "Skipping $current. Project is already ignoring lock file."
    continue
  fi

  if [ -f "package-lock.json" ]
  then
    echo "Removing lock file from $current"
    rm package-lock.json
    echo 'package-lock=false' >> .npmrc

    if [ is_git ]
    then
      git rm package-lock.json > /dev/null && \
        git add .npmrc  > /dev/null && \
        qgit commit -m "Remove package-lock.json" > /dev/null && \
        qgit push > /dev/null
    fi
  else
    echo "Ignoring $current. No lock file."
  fi
done
