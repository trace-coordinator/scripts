#!/bin/bash

DEFAULT_LOCAL_FOLDER="/home/ubuntu"
local_folder="${1:-"$DEFAULT_LOCAL_FOLDER"}"

java_installation="$local_folder"/.java
export JAVA_HOME="$java_installation"/jdk-11
if [[ ! "$PATH" =~ "$JAVA_HOME" ]]; then
    echo -e "\n<---------- SET PATH JAVA ---------->\n"
    export PATH="$JAVA_HOME"/bin:$PATH
fi
if [[ ! -d "$java_installation" ]]; then
    echo -e "\n<---------- DOWNLOAD JAVA ---------->\n"
    (
        set -euo pipefail
        mkdir -p "$java_installation"
        cd "$java_installation"
        wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
        tar xzf openjdk-11+28_linux-x64_bin.tar.gz
    )
fi

export_nvm_dir() {
    export NVM_DIR="$local_folder/.nvm"
}
source_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}
export_nvm_dir
if [[ -d "$NVM_DIR" ]]; then
    echo -e "\n<---------- UPDATE NVM ---------->\n"
else
    echo -e "\n<---------- INSTALL NVM ---------->\n"
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
fi
(
    set -euo pipefail

    cd "$NVM_DIR"
    git fetch --tags origin
    git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
    cat >"$NVM_DIR"/default-packages <<'EOF'
yarn
syncyarnlock
all-the-package-names
gitpkg
EOF
)
source_nvm
if [[ ! -d "$NVM_DIR"/versions/node/"$(nvm ls-remote --lts | tail -1 |
    awk '{ print $2 }' | sed -r "s/\x1b\[([0-9]{1,2}(;[0-9]{1,2})?)?m//g")" ]]; then

    echo -e "\n<---------- INSTALL LATEST NODE LTS ---------->\n"
    nvm install --lts
fi

# if [[ ! -d $local_folder/lttng-traces ]]; then
#     echo -e "\n<---------- COPY TRACES ---------->\n"
#     cp -r ~/lttng-traces/ $local_folder/
# fi
if [[ ! -d "$local_folder"/another-trace-coordinator ]]; then
    echo -e "\n<---------- DOWNLOAD TRACE-COORDINATOR ---------->\n"
    (
        set -euo pipefail
        git clone https://github.com/trace-coordinator/another-trace-coordinator.git "$local_folder"/another-trace-coordinator
        cd "$local_folder"/another-trace-coordinator
        yarn
    )
fi

if [[ ! -d "$local_folder"/scripts ]]; then
    echo -e "\n<---------- DOWNLOAD SCRIPTS ---------->\n"
    git clone https://github.com/trace-coordinator/scripts.git "$local_folder"/trace-server-script
fi

if [[ ! -d "$local_folder"/trace-compass-server ]]; then
    echo -e "\n<---------- DOWNLOAD TRACE COMPASS SERVER ---------->\n"
    git clone https://github.com/trace-coordinator/trace-compass-server-dev-builds.git "$local_folder"/trace-compass-server
fi

src=". \"$(realpath "$BASH_SOURCE")\""
if [[ ! "$(cat "$HOME"/.bashrc)" =~ "$src" ]]; then
    echo -e "\n<---------- CONFIG .BASHRC ---------->\n"
    echo "$src" >> "$HOME"/.bashrc
fi 
