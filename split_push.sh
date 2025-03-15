#!/bin/bash

# Default Configuration
REMOTE_NAME="origin"
BRANCH_NAME="main"
STEP_SIZE=10000

# Usage information
usage() {
    echo "Usage: $0 <path-to-commit> [-s STEP_SIZE] [-r REMOTE_NAME] [-b BRANCH_NAME]"
    exit 1
}

# Parse arguments
PATH_TO_COMMIT="$1"
shift

while getopts ":s:r:b:" opt; do
  case $opt in
    s)
      STEP_SIZE="$OPTARG"
      ;;
    r)
      REMOTE_NAME="$OPTARG"
      ;;
    b)
      BRANCH_NAME="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
esac
done

REMOTE_NAME=${REMOTE_NAME:-origin}
BRANCH_NAME=${BRANCH_NAME:-main}
STEP_SIZE=${STEP_SIZE:-10000}

if [ -z "$PATH_TO_COMMIT" ]; then
    usage
fi

# Fetch commit SHAs every STEP_SIZE commits starting from PATH_TO_COMMIT
commit_list=$(git log --oneline --reverse $PATH_TO_COMMIT | awk -v step=$STEP_SIZE 'NR % step == 0 {print $1}')

# Push commits iteratively
for commit_sha in $commit_list; do
    echo "Pushing commit $commit_sha..."
    git push $REMOTE_NAME +$commit_sha:refs/heads/$BRANCH_NAME
    if [ $? -ne 0 ]; then
        echo "Push failed at commit $commit_sha. Consider decreasing STEP_SIZE and rerunning."
        exit 1
    fi
done

# Final mirror push to ensure everything is uploaded
echo "Performing final mirror push..."
git push $REMOTE_NAME --mirror

if [ $? -eq 0 ]; then
    echo "Repository successfully pushed to GitHub."
else
    echo "Final mirror push failed. You might need to manually push remaining commits."
fi

