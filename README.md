
# GitHub Push Splitter Script

A simple Bash script to split and push large Git repositories to GitHub, circumventing the 2 GB push limit.


---

## Introduction

GitHub imposes a 2 GB size limit on pushes, which can be problematic for large repositories, such as forked Linux kernels.
For example, if you fork a large repository with many commits, you may run into the following problem when trying to push:

    $ git push <remote_repo_name> master
    Enter passphrase for key '/c/ssh/.ssh/id_rsa':
    Counting objects: 146106, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (35519/35519), done.
    fatal: pack exceeds maximum allowed size00 GiB | 154 KiB/s
    fatal: sha1 file '<stdout>' write error: Invalid arguments
    error: failed to push some refs to 'git@github.com:<repo>.git

This script solves this problem by automating the process of splitting large pushes into smaller, manageable chunks.


## Installation

1. Clone or download the script to your local machine:

```bash
git clone <repo_url>
```

2. Make the script executable:

```bash
chmod +x split_push.sh
```

## Usage

```bash
./split_push.sh <path-to-commit> [-s STEP_SIZE] [-r REMOTE_NAME] [-b BRANCH_NAME]
```

### Arguments

- **path-to-commit (required)**: The Git reference (branch name, tag, commit hash) you want to start pushing from.
- **-s STEP_SIZE (optional)**: Number of commits per push. Default is `10,000`.
- **-r REMOTE_NAME (optional)**: Remote repository name. Default is `origin`.
- **-b BRANCH_NAME (optional)**: Target branch name. Default is `main`.

### Example usage

Basic usage, with default step size and default remote/branch:

```bash
./split_push.sh main
```

Using custom arguments:

```bash
./split_push.sh v6.9-rc1 -s 5000 -r upstream -b mybranch
```

## Usage Tips

- If a push fails due to hitting the 2 GB limit, reduce the `STEP_SIZE`.
- If you stop the script, you can safely resume or adjust the `STEP_SIZE`. Git skips already-pushed commits.
- After successfully pushing commits in chunks, the script performs a final `--mirror` push to ensure all remaining refs are uploaded.

## Contributing

Feel free to fork the repository, submit pull requests, or open issues for improvements or bug fixes.

## License

This script is provided under the MIT License.


