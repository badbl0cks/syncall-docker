#!/bin/bash

# Capture the output of the task command into a variable
projects=$(task +PENDING _unique project)

# Iterate over each line in the output
echo "$projects" | while read -r project; do
  # Run the tw_gtasks_sync command with the current project
  tw_gtasks_sync -l "$project" -p "$project"
done
