#!/usr/bin/env bash

# Function to display usage
usage() {
    echo "Usage: $0 [-t curl|wget] [--type curl|wget] [-l /path/to/dir|--local /path/to/dir]"
    exit 1
}
# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "Install script must be run as root" 
   exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "Install script must be run as root" 
   exit 1
fi

# Default variant
variant=""
ipfetch_install_dir="/usr/share/ipfetch"
ipfetch_bin_dir="/usr/bin/ipfetch"

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            shift  # Shift past the option
            if [[ $1 == "curl" || $1 == "wget" ]]; then
                variant=$1
            else
                echo "Invalid option for -t/--type. Please choose 'curl' or 'wget'."
                usage
            fi
            shift  # Shift past the argument
            ;;
        -l|--local)
            shift  # Shift past the option
            if [[ -d $1 ]]; then
                ipfetch_install_dir="/usr/local/share/ipfetch"
                ipfetch_bin_dir="$HOME/.local/bin"
            else
                echo "Invalid directory specified for -l/--local. Please provide a valid directory."
                usage
            fi
            shift  # Shift past the argument
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
mkdir -p "$ipfetch_install_dir"
cp ./flags/* "$ipfetch_install_dir/"
chmod -R 755 "$ipfetch_install_dir"

# Copy the appropriate script to /usr/bin
cp "./ipfetch-$variant" "$ipfetch_bin_dir/ipfetch"
chmod 755 "$ipfetch_bin_dir/ipfetch"

echo "ipfetch has been successfully installed in $ipfetch_install_dir."