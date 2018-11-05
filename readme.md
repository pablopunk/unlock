# 🔓 Unlock

> Remove package-lock.json from your projects

## Usage

Remove the lock file from **all** the subdirectories of `src`:

```bash
$ ./unlock ~/src
```

Keep in mind you can't run this script *inside* a repo, as it will look for subfolders. If you just want to do it individually, it's very straightforward:

```bash
rm package-lock.json
echo 'package-lock=false' >> .npmrc
```

## Features

* Ignores repo if git status is not clean
* Ignores project if lock is already ignored
* Ignores project if lock does not exist
* Commits and pushes changes to your git repo
