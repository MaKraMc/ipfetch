#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "Install script must be run as root" 
   exit 1
fi

# Default variant
variant=""

# Parse command-line options
while getopts ":t:" opt; do
    case $opt in
        t)
            if [[ $OPTARG == "curl" || $OPTARG == "wget" ]]; then
                variant=$OPTARG
            else
                echo "Invalid option for -t. Please choose 'curl' or 'wget'."
                usage
            fi
            ;;
        *)
            usage
            ;;
    esac
done

# Check if a variant was specified; if not, check installed programs
if [ -z "$variant" ]; then
    # Check dependencies
    if command -v curl >/dev/null 2>&1; then
        variant=curl
        echo "Using default variant: $variant"
    elif command -v wget >/dev/null 2>&1; then
        variant=wget
        echo "Using default variant: $variant"
    else
        echo "Neither curl nor wget is installed. Please install one of them to proceed."
        exit 1
    fi
else
    echo "Installing $variant variant"
fi

# Create installation directory and set permissions
mkdir -p /usr/share/ipfetch
cp ./flags/* /usr/share/ipfetch/
chmod -R 755 /usr/share/ipfetch

# Copy the appropriate script to /usr/bin
cp ./ipfetch-$variant /usr/bin/ipfetch
chmod 755 /usr/bin/ipfetch

echo "ipfetch has been successfully installed."
