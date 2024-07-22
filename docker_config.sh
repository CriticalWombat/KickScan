#!/bin/bash

# Print a message to the console
echo "The script has been executed successfully."

# Create a file as proof
touch /tmp/script_ran_proof.txt

# Optionally, write the current date and time to the file
echo "Script ran on: $(date)" >> /tmp/script_ran_proof.txt
