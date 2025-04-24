#!/bin/bash
#
# Fixed bash script to install SubEnum's dependencies 
#

# Set colors for output
r="\e[31m"
g="\e[32m"
e="\e[0m"

echo "Starting installation with debug information..."

# Set GOPROXY for more reliable downloads
export GOPROXY=https://proxy.golang.org,direct
export GOSUMDB=off # TODO: fix that later for Amass


# First, determine the actual Go installation location
if command -v go >/dev/null 2>&1; then
    # Go is installed, get its actual path
    GO_PATH=$(which go)
    ACTUAL_GOROOT=$(dirname $(dirname $GO_PATH))
    echo "Found existing Go installation at $ACTUAL_GOROOT"
    
    # Set environment variables with actual paths
    export GOROOT=$ACTUAL_GOROOT
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    
    # Create bin directory if it doesn't exist
    mkdir -p $GOPATH/bin
    
    echo "Using GOROOT=$GOROOT"
    echo "Using GOPATH=$GOPATH"
else
    echo "No Go installation found. Will install Go."
fi

GOlang() {
    printf "                                \r"
    sys=$(uname -m)
    echo "Detected architecture: $sys"
    [ $sys == "x86_64" ] && wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz -O golang.tar.gz || wget https://golang.org/dl/go1.24.2.linux-386.tar.gz -O golang.tar.gz
    sudo tar -C /usr/local -xzf golang.tar.gz
    rm golang.tar.gz
    
    # Set environment variables for the current script session
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    
    # Create bin directory if it doesn't exist
    mkdir -p $GOPATH/bin
    
    # Add to bash config file, not zsh
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "export GOROOT=/usr/local/go" $HOME/.bashrc; then
            echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
            echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
            echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc
            echo "[+] Added Go environment variables to $HOME/.bashrc"
        fi
    fi
    
    # Check if Go is now available
    if [ -f "$GOROOT/bin/go" ]; then
        echo "Go binary found at $GOROOT/bin/go"
    else
        echo "Go binary NOT found at $GOROOT/bin/go"
    fi
    
    printf "[+] Golang Installed !.\n"
}

Findomain() {
    printf "                                \r"
    wget https://github.com/Findomain/Findomain/releases/download/9.0.4/findomain-linux.zip
    unzip findomain-linux.zip
    rm findomain-linux.zip
    chmod +x findomain
    ./findomain -h && { sudo mv findomain /usr/local/bin/; printf "[+] Findomain Installed !.\n"; } || printf "[!] Install Findomain manually: https://github.com/Findomain/Findomain/blob/master/docs/INSTALLATION.md\n"
}

Subfinder() {
    printf "                                \r"
    # Explicitly use full path to go binary
    $GOROOT/bin/go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    if [ $? -eq 0 ]; then
        printf "[+] Subfinder Installed !.\n"
    else
        printf "[!] Subfinder installation failed. Check error above.\n"
    fi
}

Amass() {
    printf "                                \r"
    # Use a specific version tag instead of master
    $GOROOT/bin/go install -v github.com/owasp-amass/amass/v4/...@v4.2.0
    if [ $? -eq 0 ]; then
        printf "[+] Amass Installed !.\n"
    else
        printf "[!] Amass installation failed. Check error above.\n"
    fi
}

Assetfinder() {
    printf "                                \r"
    $GOROOT/bin/go install github.com/tomnomnom/assetfinder@latest
    if [ $? -eq 0 ]; then
        printf "[+] Assetfinder Installed !.\n"
    else
        printf "[!] Assetfinder installation failed. Check error above.\n"
    fi
}

Httprobe() {
    printf "                                \r"
    $GOROOT/bin/go install github.com/tomnomnom/httprobe@latest
    if [ $? -eq 0 ]; then
        printf "[+] Httprobe Installed !.\n"
    else
        printf "[!] Httprobe installation failed. Check error above.\n"
    fi
}

Parallel() {
    printf "                                \r"
    sudo apt-get install parallel -y
    printf "[+] Parallel Installed !.\n"
}

Anew() {
    printf "                                \r"
    $GOROOT/bin/go install -v github.com/tomnomnom/anew@latest
    if [ $? -eq 0 ]; then
        printf "[+] Anew Installed !.\n"
    else
        printf "[!] Anew installation failed. Check error above.\n"
    fi
}

# Check if Go is installed, otherwise install it
if command -v go >/dev/null 2>&1; then 
    printf "[!] Golang is already installed.\n"
else
    printf "[+] Installing GOlang!"
    GOlang
fi

# Check if Go binary is accessible
if [ ! -f "$GOROOT/bin/go" ]; then
    echo "ERROR: Go binary not found at $GOROOT/bin/go"
    echo "Please check your Go installation and try again."
    exit 1
fi

hash findomain 2>/dev/null && printf "[!] Findomain is already installed.\n" || { printf "[+] Installing Findomain!" && Findomain; }
hash subfinder 2>/dev/null && printf "[!] subfinder is already installed.\n" || { printf "[+] Installing subfinder!" && Subfinder; }
hash amass 2>/dev/null && printf "[!] Amass is already installed.\n" || { printf "[+] Installing Amass!" && Amass; }
hash assetfinder 2>/dev/null && printf "[!] Assetfinder is already installed.\n" || { printf "[+] Installing Assetfinder!" && Assetfinder; }
hash httprobe 2>/dev/null && printf "[!] Httprobe is already installed.\n" || { printf "[+] Installing Httprobe!" && Httprobe; }
hash parallel 2>/dev/null && printf "[!] Parallel is already installed.\n" || { printf "[+] Installing Parallel!" && Parallel; }
hash anew 2>/dev/null && printf "[!] Anew is already installed.\n" || { printf "[+] Installing Anew!" && Anew; }

# DON'T try to source any shell config files to avoid zsh errors
# if [ -f ~/.bashrc ]; then
#    source ~/.bashrc
# fi

# List of tools to verify
list=(
    go
    findomain
    subfinder
    amass
    assetfinder
    httprobe
    parallel
    anew
)

echo "Verifying installations..."

# Improved verification that checks both system PATH and GOPATH/bin
for prg in ${list[@]}
do
    if command -v $prg >/dev/null 2>&1 || [ -f "$GOPATH/bin/$prg" ]; then
        printf "[$prg]$g Done$e\n"
    else
        printf "[$prg]$r Something Went Wrong! Try Again Manually.$e\n"
    fi
done

echo
echo "Installation complete."
