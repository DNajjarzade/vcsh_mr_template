#!/bin/bash
echo '
 _____        _   _                          __ _ _      
|  __ \      | \ | |                        / _(_) |     
| |  | | __ _|  \| | __ _   _ __  _ __ ___ | |_ _| | ___ 
| |  | |/ _` | . ` |/ _` | | '_ \| '__/ _ \|  _| | |/ _ \
| |__| | (_| | |\  | (_| |_| |_) | | | (_) | | | | |  __/
|_____/ \__,_|_| \_|\__,_(_) .__/|_|  \___/|_| |_|_|\___|
                           | |                           
                           |_|                           
     #  curl https://pb.najjarza.de/~setup | bash
       
     #  create short url with:
       
     #  curl -F c=@- https://pb.najjarza.de/~setup <<< $(curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash)
       
     #  long url command:
       
     #  curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash
'

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages based on the package manager
install_package() {
    if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y "$@"
    elif command_exists dnf; then
        sudo dnf install -y "$@"
    elif command_exists yum; then
        sudo yum install -y "$@"
    elif command_exists pacman; then
        sudo pacman -Sy --noconfirm "$@"
    elif command_exists apk; then
        sudo apk update
        sudo apk add "$@"        
    else
        echo "Unsupported package manager. Please install $@ manually."
        exit 1
    fi
}

# Install vcsh and mr if not already installed
if ! command_exists vcsh; then
    echo "Installing vcsh ..."
    curl -fsLS https://github.com/RichiH/vcsh/releases/latest/download/vcsh-standalone.sh -o ~/.local/bin/vcsh
    chmod +x ~/.local/bin/vcsh
fi

# Install vcsh and mr if not already installed
if ! command_exists mr; then
    echo "Installing vcsh and mr..."
    install_package myrepos mc vim git curl ansible gpg gpg-agent git-crypt
fi

# Clone the repository using vcsh
echo "Cloning the home repository..."
vcsh clone -b mr https://github.com/DNajjarzade/vcsh_mr_template.git mr
vcsh mr checkout mr
vcsh mr branch --track mr origin/mr

# Initialize and update all repositories managed by mr
echo "Initializing and updating repositories..."
mr update

echo "Setup complete!"
