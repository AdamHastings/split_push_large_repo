#!/bin/bash

# Configuration
REMOTE_NAME="origin" # Set your remote repository name here
BRANCH_NAME="main"   # Set your branch name here
STEP_SIZE=50000       # Adjust commit step size (smaller if still too big)

# Fetch commit SHAs every STEP_SIZE commits
commit_list=$(git log --oneline --reverse refs/heads/$BRANCH_NAME | awk -v step=$STEP_SIZE 'NR % step == 0 {print $1}')

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

