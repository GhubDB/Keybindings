#!/bin/bash

# Set the paths for the source and destination files
source_file="/Users/taadimo2/projects/Keybindings/karabiner/karabiner.json"
destination_file="$HOME/.config/karabiner/karabiner.json"

# Check if the source file exists
if [ -e "$source_file" ]; then
    # Remove the existing destination file if it exists
    [ -e "$destination_file" ] && rm -f "$destination_file"

    # Copy the source file to the destination
    cp "$source_file" "$destination_file"

    echo "Karabiner configuration updated successfully."
else
    cp "$source_file" "$destination_file"
    
    echo "Warning: Source file not found. Created an empty Karabiner configuration file at $destination_file."
fi
