#!/bin/bash

# Function to parse repository URLs from the webpage
parse_repos() {
    local url="$1"
    curl -s "$url" | grep -o '<a class="name" href="[^"]*"' | grep -o '"[^"]*"' | sed 's/^"\(.*\)"$/\1/'
}

# Function to clone repositories
clone_repos() {
    local base_url="https://gitea.osmocom.org/explore/repos"
    local repos=$(parse_repos "$base_url")
    local log_file="clone_log.txt"

    echo "Cloning repositories listed at $base_url..."

    # Create log file or clear existing log
    echo "" > "$log_file"

    # Iterate over repositories
    for repo in $repos; do
        echo "Cloning repository: $repo"
        git clone "$repo" >> "$log_file" 2>&1
        if [ $? -eq 0 ]; then
            echo "Cloned $repo successfully."
        else
            echo "Failed to clone $repo. Check $log_file for details."
        fi
    done

    echo "Cloning completed. See $log_file for details."
}

# Run the main function
clone_repos
