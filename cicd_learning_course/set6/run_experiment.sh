#!/bin/bash

# Ensure we are in the root of the repository
# (Assuming script is run from repo root)

echo "--- Starting Set 6: Triggering Hyperparameter Tuning ---"

# 1. Checkout main and update
git checkout main
git pull origin main

# 2. Create the specific branch required by the workflow
# Source: PDF 5 (Comparing metrics and plots in DVC), Page 26
# Quote: "Make sure to prefix branch name with hp_tune/"
# Source: PDF 5, Page 20 (Summary)
# Quote: "Branch name hp_tune/<some-string>"
BRANCH_NAME="hp_tune/experiment_$(date +%s)"
echo "Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# 3. Modify the search configuration
# Source: PDF 5, Page 20
# Quote: "Make changes to search configuration"
# We modify set5/hp_config.json to simulate a new experiment
echo "Modifying hyperparameters in set5/hp_config.json..."

cat << JSON > cicd_learning_course/set5/hp_config.json
{
  "n_estimators": [10, 20, 30],
  "max_depth": [5, 10, 15],
  "random_state": [1993]
}
JSON

# 4. Commit and Push to trigger the GitHub Action
# Source: PDF 5, Page 26
# Section: "Hyperparameter tuning job kickoff"
echo "Committing and pushing changes..."

git add cicd_learning_course/set5/hp_config.json
git commit -m "Trigger HP Tuning Experiment (Set 6)"

# Source: PDF 5, Page 24
# Purpose: This push satisfies the 'if: startsWith(github.ref, ...)' condition
git push origin "$BRANCH_NAME"

echo "---------------------------------------------------"
echo "Success! The 'HP Tuning' workflow should now be RUNNING (not skipped)."
echo "Check the Actions tab in GitHub."
echo "---------------------------------------------------"
