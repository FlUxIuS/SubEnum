#!/bin/bash
#
# bash script to install SubEnum's dependencies 
#

GOlang() {
    printf "                                \r"
    sys=$(uname -m)
    [ $sys == "x86_64" ] && wget https://go.dev/dl/go1.17.13.linux-amd64.tar.gz -O golang.tar.gz || wget https://golang.org/dl/go1.17.13.linux-386.tar.gz -O golang.tar.gz
    sudo tar -C /usr/local -xzf golang.tar.gz
    
    # Set environment variables for the current script session
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    
    # Create bin directory if it doesn't exist
    mkdir -p $GOPATH/bin
    
    echo "[!] Add The Following Lines To Your ~/.${SHELL##*/}rc file:"
    echo 'export GOROOT=/usr/local/go'
    echo 'export GOPATH=$HOME/go'
    echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin'
    
    printf "[+] Golang Installed !.\n"
}

Findomain() {
    printf "                                \r"
    wget https://github.com/Findomain/Findomain/releases/download/8.2.1/findomain-linux.zip
    unzip findomain-linux.zip
    rm findomain-linux.zip
    chmod +x findomain
    ./findomain -h && { sudo mv findomain /usr/local/bin/; printf "[+] Findomain Installed !.\n"; } || printf "[!] Install Findomain manually: https://github.com/Findomain/Findomain/blob/master/docs/INSTALLATION.md\n"
}

Subfinder() {
    printf "                                \r"
    # Remove output redirection to see errors
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    if [ $? -eq 0 ]; then
        printf "[+] Subfinder Installed !.\n"
    else
        printf "[!] Subfinder installation failed. Check error above.\n"
    fi
}

Amass() {
    printf "                                \r"
    go install -v github.com/owasp-amass/amass/v4/...@master
    if [ $? -eq 0 ]; then
        printf "[+] Amass Installed !.\n"
    else
        printf "[!] Amass installation failed. Check error above.\n"
    fi
}

Assetfinder() {
    printf "                                \r"
    go install github.com/tomnomnom/assetfinder@latest
    if [ $? -eq 0 ]; then
        printf "[+] Assetfinder Installed !.\n"
    else
        printf "[!] Assetfinder installation failed. Check error above.\n"
    fi
}

Httprobe() {
    printf "                                \r"
    go install github.com/tomnomnom/httprobe@latest
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
    go install -v github.com/tomnomnom/anew@latest
    if [ $? -eq 0 ]; then
        printf "[+] Anew Installed !.\n"
    else
        printf "[!] Anew installation failed. Check error above.\n"
    fi
}

# Check if Go is installed, otherwise install it
hash go 2>/dev/null && printf "[!] Golang is already installed.\n" || { printf "[+] Installing GOlang!" && GOlang; }

# If Go was just installed, we need to ensure the environment variables are set
if ! hash go 2>/dev/null; then
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    mkdir -p $GOPATH/bin
fi

hash findomain 2>/dev/null && printf "[!] Findomain is already installed.\n" || { printf "[+] Installing Findomain!" && Findomain; }
hash subfinder 2>/dev/null && printf "[!] subfinder is already installed.\n" || { printf "[+] Installing subfinder!" && Subfinder; }
hash amass 2>/dev/null && printf "[!] Amass is already installed.\n" || { printf "[+] Installing Amass!" && Amass; }
hash assetfinder 2>/dev/null && printf "[!] Assetfinder is already installed.\n" || { printf "[+] Installing Assetfinder!" && Assetfinder; }
hash httprobe 2>/dev/null && printf "[!] Httprobe is already installed.\n" || { printf "[+] Installing Httprobe!" && Httprobe; }
hash parallel 2>/dev/null && printf "[!] Parallel is already installed.\n" || { printf "[+] Installing Parallel!" && Parallel; }
hash anew 2>/dev/null && printf "[!] Anew is already installed.\n" || { printf "[+] Installing Anew!" && Anew; }

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

r="\e[31m"
g="\e[32m"
e="\e[0m"

for prg in ${list[@]}
do
    hash $prg 2>/dev/null && printf "[$prg]$g Done$e\n" || printf "[$prg]$r Something Went Wrong! Try Again Manually.$e\n"
done
