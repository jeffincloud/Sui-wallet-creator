#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq to run this script."
    exit 1
fi

# Prompt for the number of addresses to create
read -p "Enter the number of addresses to create: " num_addresses

# Check if the input is a valid number
if ! [[ "$num_addresses" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid number."
    exit 1
fi

# Create a CSV file with headers
output_file="sui_addresses.csv"
echo "Alias;Address;Public Key;Recovery Phrase" > "$output_file"

# Loop to create addresses
for ((i=1; i<=$num_addresses; i++))
do
    # Create new address using sui client and capture JSON output
    output=$(sui client new-address ed25519 --json)

    # Extract information from JSON output
    alias=$(echo "$output" | jq -r '.alias')
    address=$(echo "$output" | jq -r '.address')
    public_key=$(echo "$output" | jq -r '.publicKey.publicKey')
    recovery_phrase=$(echo "$output" | jq -r '.recoveryPhrase')

    # Append to CSV file
    echo "$alias;$address;$public_key;$recovery_phrase" >> "$output_file"

    echo "Created address $i of $num_addresses"
done

echo "All addresses have been created and saved to $output_file"

# Display the contents of the file (first few lines)
echo "Preview of $output_file:"
head -n 5 "$output_file"