#!/bin/bash

# List of programs to be installed
programs=(
    "git"
    "openssh"
    "zsh"
    "antigen"
    "oh-my-posh"
    "pyenv"
    "go"
    "build-essentials"
)

install_curl() {
    # Check if curl is installed
    if command -v curl &> /dev/null; then
        echo "curl is already installed."
    else
        echo "curl is not installed. Installing..."
        
        # Determine the package manager and install curl
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y curl
        elif command -v yum &> /dev/null; then
            sudo yum install -y curl
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy curl --noconfirm
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y curl
        else
            echo "Unsupported package manager. Please install curl manually."
            exit 1
        fi

        echo "curl installation complete!"
    fi
}

install_homebrew() {
    echo "Installing Homebrew..."
    if command -v brew &> /dev/null; then
        echo "Homebrew is already installed."
    else
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

install_brew_packages() {
    for program in "${programs[@]}"; do
        if brew list -1 | grep -q "^${program}\$"; then
            echo "$program is already installed."
        else
            echo "$program is not installed. Installing..."
            brew install "$program"
        fi
    done
}

setup_shell_links() {
    # Set variables
    local REPO_URL="https://github.com/Savedbygrace251/linux-setup.git" # Replace with your repository URL
    local REPO_DIR="$HOME/projects/linux-setup" # Replace with the name of your repository
    local SHELL_DIR="$REPO_DIR/shell"

    # Clone or update the repository
    if [ -d "$REPO_DIR/.git" ]; then
        echo "Repository already cloned. Checking for updates..."
        cd "$REPO_DIR" && git pull
    else
        echo "Cloning repository..."
        git clone "$REPO_URL" "$REPO_DIR"
    fi

    # Function to create symbolic links and back up existing files
    link_files() {
        local src_dir="$1"
        local dest_dir="$2"

        for file in "$src_dir"/*; do
            local dest_file="$dest_dir/$(basename "$file")"

            if [ -d "$file" ]; then
                # Create directory if it doesn't exist and recurse
                mkdir -p "$dest_file"
                link_files "$file" "$dest_file"
            elif [ -f "$file" ]; then
                # Check if the destination file is already a correct symbolic link
                if [ -L "$dest_file" ] && [ "$(readlink "$dest_file")" = "$file" ]; then
                    echo "Already linked: $dest_file"
                else
                    # Backup existing files and create symbolic link
                    if [ -e "$dest_file" ]; then
                        echo "Backing up existing file: $dest_file"
                        mv "$dest_file" "$dest_file.bak"
                    fi
                    echo "Linking $file to $dest_file"
                    ln -s "$file" "$dest_file"
                fi
            fi
        done
    }

    # Link all files from the shell directory to the home directory
    link_files "$SHELL_DIR" "$HOME"
}


# Main script execution
install_curl
install_homebrew
install_brew_packages
setup_shell_links

source $HOME/.zshrc

echo "Setup complete!"