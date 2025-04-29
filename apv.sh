#!/bin/bash

if [ -z "$APV_TARGET_GITHUB_REPO" ]; then
  echo "❌ Environment variable APV_TARGET_GITHUB_REPO is not set."
  echo "🔍 Please set the environment variable: export APV_TARGET_GITHUB_REPO=\"your-repo-name\""
  exit 1
else
  echo "🔍 Using GitHub repo from environment variable: $APV_TARGET_GITHUB_REPO"
fi

echo "🤟 Enter the string to search for :"
read MATCH_STRING

if [ -z "$MATCH_STRING" ]; then
  echo "🚧 No string was entered."
  exit 1
fi

# Get the list of open PRs
gh pr list --repo "$REPO" --state open --json number,title,body \
  --jq '.[] | select(.body | contains("'"$MATCH_STRING"'")) | "\(.number)|\(.title)"' | while IFS='|' read pr_number pr_title
do
  echo "✅ Approving PR #$pr_number: $pr_title"
  gh pr review "$pr_number" --repo "$REPO" --approve
done